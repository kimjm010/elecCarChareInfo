//
//  ChargeStnInfoTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/13/22.
//

import UIKit

class ChargeStnInfoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - UITableView DataSource
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyChargeStation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoTableViewCell
        
        let chargeStn = dummyChargeStation[indexPath.row].chargeStn
        cell.stnPlaceLabel.text = chargeStn.stnPlace
        cell.stnAddrLabel.text = chargeStn.stnAddr
        cell.slowChargerStatusLabel.text = "완속: \(chargeStn.slowCnt)"
        cell.rapidChargerStatusLabel.text = "완속: \(chargeStn.rapidCnt)"
        
        return cell
    }
    
    
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
