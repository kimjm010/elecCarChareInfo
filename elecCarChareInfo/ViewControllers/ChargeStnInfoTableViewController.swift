//
//  ChargeStnInfoTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/13/22.
//

import UIKit
import CoreLocation
import MapKit


class ChargeStnInfoTableViewController: UITableViewController {
    
    // MARK: - Vars
    var chargeStn: ChargeStation?
    
    // MARK: - IBOutlets
    @IBOutlet var chargeStationInfoTableView: UITableView!
    
    
    // MARK: - IBActions
    
    @IBAction func findRouteTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Add Route
    
    private func addRoute(to coordinate: CLLocationCoordinate2D) {
        
    }
    
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        
        let chargeStn = dummyChargeStationData[indexPath.row]
        cell.configure(chargeStation: chargeStn) { (chargeStation) in
            cell.slowChargeLabel.text = "완속: \(chargeStn.slowCnt)"
            cell.rapidChargeLabel.text = "완속: \(chargeStn.rapidCnt)"
            
            cell.slowChargeContainerView.isHidden = chargeStation.slowCnt > 0 ? false : true
            cell.rapidChargeContainerView.isHidden = chargeStation.rapidCnt > 0 ? false : true
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
