import Foundation
import MapsIndoors

extension ViewController {

    // Functions for Live Data
    @objc func toggleLivePosition() {
        isLivePositionEnabled.toggle()
        if isLivePositionEnabled {
            mapControl?.enableLiveData(domain: MPLiveDomainType.position) { liveUpdate in
                // Handle the live position updates here
                print("Position live update: \(liveUpdate)")
            }
        } else {
            mapControl?.disableLiveData(domain: MPLiveDomainType.position)
        }
    }

    @objc func toggleLiveOccupancy() {
        isLiveOccupancyEnabled.toggle()
        if isLiveOccupancyEnabled {
            mapControl?.enableLiveData(domain: MPLiveDomainType.occupancy) { liveUpdate in
                // Handle the live occupancy updates here
                print("Occupancy live update: \(liveUpdate)")
            }
        } else {
            mapControl?.disableLiveData(domain: MPLiveDomainType.occupancy)
        }
    }

}
