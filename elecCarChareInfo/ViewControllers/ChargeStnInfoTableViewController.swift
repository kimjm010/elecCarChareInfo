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
    
    var token: NSObjectProtocol?
    
    // MARK: - IBOutlets
    @IBOutlet var chargeStationInfoTableView: UITableView!
    
    
    // MARK: - IBActions
    
    @IBAction func findRouteTapped(_ sender: Any) {
        
        // TODO: iOS Map으로 연결하여 루트 보여주기
        print(#function)
    }
    
    
    // MARK:
    
    @objc
    private func dataRecieved(_ notification: Notification) {
        if let chargeStn = chargeStn {
            print(chargeStn.stnPlace)
        }
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: .sendDataToChargeInfoVC, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let data = noti.userInfo?["charge"] as? ChargeStation else { return }
            print(data, self?.chargeStn?.stnPlace)
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(token)
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
