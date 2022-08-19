//
//  CarTypeTableViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/15/22.
//

import UIKit

class CarTypeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    
    func configure(carType: String, completion: () -> ()) {
        carTypeLabel.text = carType
        completion()
    }
}
