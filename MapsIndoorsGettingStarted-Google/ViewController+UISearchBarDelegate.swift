import MapsIndoors
import MapsIndoorsCore
import UIKit

extension ViewController: UISearchBarDelegate {

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

}
