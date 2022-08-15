//
//  ChargeTypeTableViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/15/22.
//

import UIKit

class ChargeTypeTableViewCell: UITableViewCell {
    
    // MARK: -IBOutlets
    @IBOutlet weak var slowChargeButton: UIButton!
    @IBOutlet weak var rapidChargeButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        slowChargeButton.setEnableBtnTheme()
        rapidChargeButton.setEnableBtnTheme()
    }
}
