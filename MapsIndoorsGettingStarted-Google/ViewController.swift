//  ViewController.swift
import UIKit
import MapsIndoorsCore
import MapsIndoorsGoogleMaps
import GoogleMaps

class ViewController: UIViewController {
    
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
            // Load MapsIndoors with the MapsIndoors API key.
            let error = await MPMapsIndoors.shared.load(apiKey: AppDelegate.mApiKey)
            if let mapConfig = mapConfig {
                if let mapControl = MPMapsIndoors.createMapControl(mapConfig: mapConfig) {
                    
                    let query = MPQuery()
                    let filter = MPFilter()
                    
                    query.query = "Family Dining Room"
                    filter.take = 1
                    
                    let locations = await MPMapsIndoors.shared.locationsWith(query: query, filter: filter)
                    if let firstLocation = locations.first {
                        mapControl.select(location: firstLocation, behavior: .default)
                        mapControl.select(floorIndex: firstLocation.floorIndex.intValue)
                    }
                }
            }
        }
    }
}
