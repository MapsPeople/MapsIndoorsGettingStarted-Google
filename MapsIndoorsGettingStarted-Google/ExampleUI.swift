import UIKit

class ExampleUI {
    
    class func create(parentView: UIView, searchDelegate: UISearchBarDelegate) {
        let searchBar = addSearchBar(parentView: parentView, delegate: searchDelegate)
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
    
}
