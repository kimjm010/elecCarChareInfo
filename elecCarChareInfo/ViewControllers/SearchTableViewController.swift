//
//  SearchTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/22/22.
//

import UIKit

// TODO: search 결과 plact + addr 인것 같으니 확인 할 것


class SearchTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var searchTableView: UITableView!
    
    
    // MARK: - Vars
    
    var filteredList = [ChargeStation]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !(isSearchBarEmpty)
    }
    
    var cachedText: String?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    
    // MARK: - Setup
    
    /// searchController 초기화
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter Charge Station Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredList = dummyChargeStationData.filter { (chargeStn) -> Bool in
            return chargeStn.stnPlace.lowercased().contains(searchText.lowercased())
        }
        
        searchTableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return dummyChargeStationData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var target: ChargeStation
        
        if isFiltering {
            target = filteredList[indexPath.row]
        }
        
        target = dummyChargeStationData[indexPath.row]
        
        cell.textLabel?.text = target.stnPlace
        cell.detailTextLabel?.text = target.stnAddr

        return cell
    }
}




// MARK: - UISearchResultsUpdating

extension SearchTableViewController: UISearchResultsUpdating {
    
    /// searchBar의 내용이 변경되는 경우 호출합니다.
    /// - Parameter searchController: searchController
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        filterContentForSearchText(text)
    }
}




// MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {
    
    /// searchBar검색 내용이 바뀔때마다 호출합니다.
    /// - Parameters:
    ///   - searchBar: searchBar
    ///   - searchText: searchBar에 입력된 text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        cachedText = searchText
    }
    
    
    /// 검색 종료 시 호출합니다.
    /// - Parameter searchBar: searchBar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = cachedText, !(text.isEmpty || filteredList.isEmpty) else { return }
        searchController.searchBar.text = text
    }
    
    
    /// 검색 혹은 Return버튼 클릭시 호출합니다.
    /// - Parameter searchBar: searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
    }
}