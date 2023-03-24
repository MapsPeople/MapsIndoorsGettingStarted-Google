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
        
        // Initialize the MPMapConfig with the GMSMapView
        mapConfig = MPMapConfig(gmsMapView: mapView, googleApiKey: AppDelegate.gApiKey!)
        
        // Initialize the MPMapControl with the MPMapConfig.
        Task {
            // Load MapsIndoors with the MapsIndoors API key.
            await MPMapsIndoors.shared.load(apiKey: AppDelegate.mApiKey)
            if let mapConfig = mapConfig {
                mapControl = MPMapsIndoors.createMapControl(mapConfig: mapConfig)
                // further set up SDK.
                // ...
            }
        }
    }
}
