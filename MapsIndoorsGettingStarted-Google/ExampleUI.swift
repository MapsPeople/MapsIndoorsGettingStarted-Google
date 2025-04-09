import UIKit

class ExampleUI {
    
    class func create(parentView: UIView, searchDelegate: UISearchBarDelegate) {
        let searchBar = addSearchBar(parentView: parentView, delegate: searchDelegate)
        let livePositionButton = addLivePositionButton(parentView: parentView)
        let liveOccupancyButton = addLiveOccupancyButton(parentView: parentView)

        NSLayoutConstraint.activate([
            livePositionButton.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            livePositionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),

            liveOccupancyButton.leadingAnchor.constraint(equalTo: livePositionButton.trailingAnchor, constant: 16),
            liveOccupancyButton.centerYAnchor.constraint(equalTo: livePositionButton.centerYAnchor),
        ])
    }
    
    class func addSearchBar(parentView: UIView, delegate: UISearchBarDelegate) -> UIView {
        let destinationSearch = UISearchBar(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        destinationSearch.sizeToFit()
        destinationSearch.delegate = delegate
        destinationSearch.barTintColor = UIColor(red: 35 / 255, green: 85 / 255, blue: 84 / 255, alpha: 1)
        destinationSearch.searchTextField.textColor = .white
        destinationSearch.searchTextField.backgroundColor = UIColor(red: 75 / 255, green: 125 / 255, blue: 124 / 255, alpha: 0.3)
        destinationSearch.searchTextField.layer.cornerRadius = 8
        destinationSearch.searchTextField.clipsToBounds = true
        parentView.addSubview(destinationSearch)
        
        return destinationSearch
    }
    
    class func addLivePositionButton(parentView: UIView) -> UIView {
        let livePositionButton = UIButton(type: .custom)
        livePositionButton.setTitle("Toggle Live Position", for: .normal)
        livePositionButton.backgroundColor = UIColor(red: 35 / 255, green: 85 / 255, blue: 84 / 255, alpha: 1)
        livePositionButton.setTitleColor(.white, for: .normal)
        livePositionButton.layer.cornerRadius = 8
        livePositionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        livePositionButton.translatesAutoresizingMaskIntoConstraints = false
        livePositionButton.addTarget(nil, action: #selector(ViewController.toggleLivePosition), for: .touchUpInside)
        parentView.addSubview(livePositionButton)
        
        return livePositionButton
    }
    
    class func addLiveOccupancyButton(parentView: UIView) -> UIView {
        let liveOccupancyButton = UIButton(type: .custom)
        liveOccupancyButton.setTitle("Toggle Live Occupancy", for: .normal)
        liveOccupancyButton.backgroundColor = UIColor(red: 35 / 255, green: 85 / 255, blue: 84 / 255, alpha: 1)
        liveOccupancyButton.setTitleColor(.white, for: .normal)
        liveOccupancyButton.layer.cornerRadius = 8
        liveOccupancyButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        liveOccupancyButton.translatesAutoresizingMaskIntoConstraints = false
        liveOccupancyButton.addTarget(nil, action: #selector(ViewController.toggleLiveOccupancy), for: .touchUpInside)
        parentView.addSubview(liveOccupancyButton)
        
        return liveOccupancyButton
    }

}
