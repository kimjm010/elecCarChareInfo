//
//  ShowRouteViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/17/22.
//

import UIKit
import MapKit


class ShowRouteViewController: UIViewController {
    
    // MARK: - Vars
    var chargeStn: ChargeStation?
    var annotation: MKAnnotation?
    
    
    // MARK: - IBActions
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
