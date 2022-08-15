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
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ChargeTypeTableViewCell", for: indexPath) as! ChargeTypeTableViewCell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "차종"
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTypeTableViewCell", for: indexPath) as! CarTypeTableViewCell
        
        let cartype = carTypes[indexPath.row]
        cell.configure(carType: cartype) {
            print(#function, "셀에 부담이 안되게 하는 작업")
        }
        
        return cell
    }
    
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
