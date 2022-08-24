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

    
    /// TabBar Controller의 배경색을 설정합니다.
    /// tab bar의 배경색을 시스템 기본 배경색으로 설정하고, scrollEdgeAppearance와 일치시킵니다.
    /// 일부 화면에서 tab bar가 투명해지는 현상을 해결할 수 있습니다.
    func setTabBarAppearanceAsDefault() {
        if #available(iOS 15.0, *) {
            guard let tabBarController = self.tabBarController else { return }
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
    }
    
}
