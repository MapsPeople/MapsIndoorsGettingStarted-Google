//  ViewController.swift
import UIKit
import MapsIndoorsCore
import MapsIndoorsGoogleMaps
import GoogleMaps

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // Add the renderer property and origin point(static for demo purpose)
    var directionsRenderer: MPDirectionsRenderer?
    var origin: MPLocation?
    
    // Add this property to hold a reference to the MPMapControl object
    var mpMapControl: MPMapControl?
    
    var searchResult: [MPLocation]?
    lazy var destinationSearch = UISearchBar(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
    var tableView = UITableView(frame: CGRect(x: 0, y: 90, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    // Buttons for Live Data
    lazy var livePositionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Toggle Live Position", for: .normal)
        button.addTarget(self, action: #selector(toggleLivePosition), for: .touchUpInside)
        return button
    }()
    
    lazy var liveOccupancyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Toggle Live Occupancy", for: .normal)
        button.addTarget(self, action: #selector(toggleLiveOccupancy), for: .touchUpInside)
        return button
    }()
    
    var isLivePositionEnabled = false
    var isLiveOccupancyEnabled = false
    
    var mapView: GMSMapView!
    var mapConfig: MPMapConfig?
    var mapControl: MPMapControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Google Maps view. Centered on The White House. Change this to center on a building in your MapsIndoors dataset
        let camera = GMSCameraPosition.camera(withLatitude: 38.8977, longitude: -77.0365, zoom: 20)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        view.addSubview(mapView)
        
        // Set up the autoresizing mask to keep the map's frame synced with the view controller's frame.
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Initialize the MPMapConfig with the GMSMapView. A MPMapConfig is needed to initialise MPMapsIndoors.
        mapConfig = MPMapConfig(gmsMapView: mapView, googleApiKey: AppDelegate.gApiKey!)
        
        Task {
            do {
                // Load MapsIndoors with the MapsIndoors API key.
                try await MPMapsIndoors.shared.load(apiKey: AppDelegate.mApiKey)
                
                if let mapConfig = mapConfig {
                    if let mapControl = MPMapsIndoors.createMapControl(mapConfig: mapConfig) {
                        
                        // Retain the mapControl object
                        self.mpMapControl = mapControl
                        
                        let query = MPQuery()
                        let filter = MPFilter()
                        
                        query.query = "Family Dining Room"
                        filter.take = 1
                        
                        let locations = await MPMapsIndoors.shared.locationsWith(query: query, filter: filter)
                        if let firstLocation = locations.first {
                            mapControl.select(location: firstLocation, behavior: .default)
                            mapControl.select(floorIndex: firstLocation.floorIndex.intValue)
                            // set the origin as Family Dining room
                            origin = firstLocation
                        }
                    }
                }
                
            } catch {
                print("Error loading MapsIndoors: \(error.localizedDescription)")
            }
        }
        
        destinationSearch.sizeToFit()
        destinationSearch.delegate = self
        view.addSubview(destinationSearch)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add the buttons to the view and set their constraints
        view.addSubview(livePositionButton)
        view.addSubview(liveOccupancyButton)
        
        livePositionButton.translatesAutoresizingMaskIntoConstraints = false
        liveOccupancyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            livePositionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            livePositionButton.topAnchor.constraint(equalTo: destinationSearch.bottomAnchor, constant: 8),
            
            liveOccupancyButton.leadingAnchor.constraint(equalTo: livePositionButton.trailingAnchor, constant: 16),
            liveOccupancyButton.centerYAnchor.constraint(equalTo: livePositionButton.centerYAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let location = searchResult?[indexPath.row]
        cell.textLabel?.text = location?.name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = searchResult?[indexPath.row] else { return }
        mpMapControl?.goTo(entity: location) // Use the retained mpMapControl object
        tableView.removeFromSuperview()
        
        // Call the directions(to:) function
        directions(to: location)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        view.addSubview(tableView)
        let query = MPQuery()
        let filter = MPFilter()
        query.query = searchText
        filter.take = 100
        Task {
            searchResult = await MPMapsIndoors.shared.locationsWith(query: query, filter: filter)
            tableView.reloadData()
        }
    }
    
    func directions(to destination: MPLocation) {
        guard let mapControl = mpMapControl else { return }
        
        if directionsRenderer == nil {
            directionsRenderer = mapControl.newDirectionsRenderer()
        }
        
        let directionsQuery = MPDirectionsQuery(origin: origin!, destination: destination)
        
        Task {
            do {
                let route = try await MPMapsIndoors.shared.directionsService.routingWith(query: directionsQuery)
                directionsRenderer?.route = route
                directionsRenderer?.routeLegIndex = 0
                directionsRenderer?.animate(duration: 5)
            } catch {
                print("Error getting directions: \(error.localizedDescription)")
            }
        }
    }
    
    // Functions for Live Data
    @objc func toggleLivePosition() {
        isLivePositionEnabled.toggle()
        if isLivePositionEnabled {
            mpMapControl?.enableLiveData(domain: MPLiveDomainType.position) { liveUpdate in
                // Handle the live position updates here
                print("Position live update: \(liveUpdate)")
            }
        } else {
            mpMapControl?.disableLiveData(domain: MPLiveDomainType.position)
        }
    }

    @objc func toggleLiveOccupancy() {
        isLiveOccupancyEnabled.toggle()
        if isLiveOccupancyEnabled {
            mpMapControl?.enableLiveData(domain: MPLiveDomainType.occupancy) { liveUpdate in
                // Handle the live occupancy updates here
                print("Occupancy live update: \(liveUpdate)")
            }
        } else {
            mpMapControl?.disableLiveData(domain: MPLiveDomainType.occupancy)
        }
    }
}
