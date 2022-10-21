//
//  UIViewController+Alert.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/15/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 위치 권한에 따른 알림
    /// - Parameters:
    ///   - title: 알림 title
    ///   - message: 알림 message
    ///   - completion: completion Handler
    func alertLocationAuth(title: String, message: String, completion: ((UIAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let laterAction = UIAlertAction(title: "나중에 하기", style: .cancel, handler: nil)
        alert.addAction(laterAction)
        
        let goToSetting = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(goToSetting)
        
        present(alert, animated: true, completion: nil)
    }

    
    
    func alertLogOut(title: String, okActionTitle: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive, handler: completion)
        alert.addAction(okAction)
        
        let cxlAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cxlAction)
        
        present(alert, animated: true, completion: nil)
    }
}



extension ChargeStationViewModel {
    
    /// 위치 권한에 따른 알림
    /// - Parameters:
    ///   - title: 알림 title
    ///   - message: 알림 message
    ///   - completion: completion Handler
    func alertLocationAuth(title: String, message: String, completion: ((UIAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let laterAction = UIAlertAction(title: "나중에 하기", style: .cancel, handler: nil)
        alert.addAction(laterAction)
        
        let goToSetting = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(goToSetting)
        
//        present(alert, animated: true, completion: nil)
    }

    
    
    func alertLogOut(title: String, okActionTitle: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive, handler: completion)
        alert.addAction(okAction)
        
        let cxlAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cxlAction)
        
//        present(alert, animated: true, completion: nil)
    }
}
