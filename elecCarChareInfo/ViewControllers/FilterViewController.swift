//
//  FilterViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/19/22.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Vars
    
    var carTypes: [CarType] = {
        var typeName = [String]()
        var types = [CarType]()
        
        for i in 0 ..< dummyChargeStationData.count {
            typeName = dummyChargeStationData[i].carType.name.components(separatedBy: ",")
            types.append(CarType(name: typeName[i], isSelected: false))
        }
        
        return types
    }()
    
    var filteredList = [ChargeStation]()
    
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var filterTableView: UITableView!

    
    // MARK: - IBActions
    
    @IBAction func slowChargeBtnTapped(_ sender: Any) {
        // TODO: 완속 충전소만 필터링 하기
    }
    
    
    @IBAction func rapidChargeBtnTapped(_ sender: Any) {
        // TODO: 급속 충전소만 필터링 하기
    }
    

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(closeVC))]
    }
    
    
    @objc
    private func closeVC() {
        // TODO: viewController dismiss하기 + filteredList 넘겨주기
    }
}




// MARK: - TableView DataSource

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTypeTableViewCell", for: indexPath) as! CarTypeTableViewCell
        
        let cartype = carTypes[indexPath.row]
        cell.configure(carType: cartype.name) {
            cell.checkboxImageView.isHighlighted = cartype.isSelected
        }
        
        return cell
    }
}




// MARK: - TableView Delegate

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CarTypeTableViewCell
        let isSelected = carTypes[indexPath.row].isSelected ? false : true
        
        cell.checkboxImageView.isHighlighted = isSelected
        carTypes[indexPath.row].isSelected = cell.checkboxImageView.isHighlighted
    }
}
