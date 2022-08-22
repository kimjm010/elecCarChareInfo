//
//  OptionsCollectionViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var optionsContainerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionsContainerView.layer.cornerRadius = 10
    }
    
    
    // MARK: - Setup Cell
    
    func configure(option: Option) {
        optionLabel.text = option.optionName
    }
}
