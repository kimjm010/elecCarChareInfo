//
//  OptionsCollectionViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var optionImageView: UIImageView!
    
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var optionsContainerStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionsContainerStackView.layer.cornerRadius = 10
    }
    
    // MARK: - Setup Cell
    
    func configure(option: Option, completion: () -> ()) {
        optionLabel.text = option.optionName
        completion()
    }
}
