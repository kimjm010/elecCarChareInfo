//
//  SearchTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/22/22.
//

import NSObject_Rx
import RxSwift
import UIKit


#warning("Todo: - 필터링 기능 버그 있어요. 첫번째 데이터만 나오네요")
class SearchTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var searchTableView: UITableView!
    
    
    // MARK: - Vars
    
    var filteredList = [LocalChargeStation]()
    
    var stationList = [LocalChargeStation]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var cachedText: String?
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !(isSearchBarEmpty)
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        ParseChargeStation.shared.chargeStnListObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.stationList = $0
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    // MARK: - Setup
    
    /// Initialize Search Controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter Charge Station Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredList = stationList.filter { (chargeStn) -> Bool in
            return chargeStn.stnPlace.lowercased().contains(searchText.lowercased())
        }
        
        searchTableView.reloadData()
    }
    

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return stationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var target: LocalChargeStation
        
        if isFiltering {
            target = filteredList[indexPath.row]
        }
        
        target = stationList[indexPath.row]
        
        cell.textLabel?.text = target.stnPlace
        cell.detailTextLabel?.text = target.stnAddr

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




// MARK: - UISearchResults Updating

extension SearchTableViewController: UISearchResultsUpdating {
    
    /// searchBar의 내용이 변경되는 경우 호출합니다.
    ///
    /// - Parameter searchController: searchController
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        filterContentForSearchText(text)
    }
}




// MARK: - UISearchBar Delegate

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
