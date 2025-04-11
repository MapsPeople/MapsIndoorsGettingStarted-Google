import UIKit

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = searchResult?[indexPath.row] else { return }
        mapControl?.goTo(entity: location)  // Use the retained mpMapControl object
        tableView.removeFromSuperview()

        // Call the directions(to:) function to get directions to the selected search result
        directions(to: location)
    }

}
