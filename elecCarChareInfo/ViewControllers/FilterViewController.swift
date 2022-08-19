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
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var chargeTypeControl: UISegmentedControl!
    
    
    
    // MARK: - IBActions
    
    @IBAction func toggleChargeType(_ sender: UISegmentedControl!) {
        
        if sender.selectedSegmentIndex == 0 {
            // TODO: 완속 충전소가 있는 곳만 보여주기 -> 완속 없는 곳은 필터에서 없애기
        }
    }
    
    

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(closeVC))]
        
    }
    
    
    @objc
    private func closeVC() {
        dismiss(animated: true)
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
