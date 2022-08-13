//
//  OptionsCollectionViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    
    func configure(option: Option, completion: () -> ()) {
        optionLabel.text = option.optionName
        completion()
    }
    
}
