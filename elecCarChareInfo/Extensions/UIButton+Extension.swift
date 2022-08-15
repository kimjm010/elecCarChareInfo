//
//  UIButton+Extension.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/15/22.
//

import Foundation
import UIKit


extension UIButton {
    
    /// 기본 Enable된 버튼의 테마를 설정합니다.
    func setEnableBtnTheme() {
        self.backgroundColor = .systemBlue
        self.tintColor = .white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    /// 기본 Disabled된 버튼의 테마를 설정합니다.
    func setDisabledBtnTheme() {
        self.backgroundColor = .systemBlue
        self.tintColor = .white
        self.alpha = 0.3
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
}
