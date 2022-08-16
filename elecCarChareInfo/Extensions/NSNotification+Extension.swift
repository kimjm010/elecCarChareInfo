//
//  NSNotification+Extension.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/16/22.
//

import Foundation


extension NSNotification.Name {
    
    /// callOut을 탭했을 때 ChargeStation 객체를 ChargeInfoStnTableViewController로 전달합니다.
    static let sendDataToChargeInfoVC = NSNotification.Name(rawValue: "sendDataToChargeInfoVC")
}
