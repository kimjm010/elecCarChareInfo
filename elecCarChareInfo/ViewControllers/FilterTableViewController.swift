//
//  FilterTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/13/22.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var filterListTableView: UITableView!
    
    // MARK: - Vars
    var carTypes: [String] = {
        var values = [String]()
        for i in 0 ..< dummyChargeStationData.count {
            values = dummyChargeStationData[i].carType.components(separatedBy: ",")
        }
        
        return values
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1:
            return 1
        case 2:
            return carTypes.count
        default:
            break
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarTypeTableViewCell", for: indexPath) as! CarTypeTableViewCell
            
            let carType = carTypes[indexPath.row]
            cell.configure(carType: carType) {
                print("셀에 부담이 안가게 여기서 작업")
            }
            
            return cell
        }
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ChargeTypeTableViewCell", for: indexPath) as! ChargeTypeTableViewCell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
    }
}
