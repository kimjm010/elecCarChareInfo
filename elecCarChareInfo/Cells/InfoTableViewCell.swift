//
//  InfoTableViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var stnPlaceLabel: UILabel!
    @IBOutlet weak var stnAddrLabel: UILabel!
    @IBOutlet weak var slowChargeContainerView: UIStackView!
    @IBOutlet weak var rapidChargeContainerView: UIStackView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slowChargeLabel: UILabel!
    @IBOutlet weak var rapidChargeLabel: UILabel!
    @IBOutlet weak var getDirectionButton: UIButton!
    
    override func awakeFromNib() {
        getDirectionButton.setEnableBtnTheme()
    }
    
    
    func configure(chargeStation: ChargeStation, completion: @escaping (_ chargeStation: ChargeStation) -> Void) {
        stnPlaceLabel.text = chargeStation.stnPlace
        stnAddrLabel.text = chargeStation.stnAddr
        completion(chargeStation)
    }
}
