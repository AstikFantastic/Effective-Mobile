import UIKit

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchbar: UISearchBar) {
        searchbar.text = ""
        presenter?.search(text: "")
        searchbar.resignFirstResponder()
        
    }
}
