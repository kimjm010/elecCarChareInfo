//
//  UIView+Extensions.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/29/22.
//

import Foundation
import UIKit


extension UIView {
    
    func setEvenComment() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
    }
    
    
    func setOddComment() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
    }
}
