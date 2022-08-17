//
//  SceneDelegate.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // TODO: 화면 모드 변경할 것
        let token = NotificationCenter.default.addObserver(forName: .changeThmeme, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            guard let theme = noti.userInfo?["changeTheme"] as? Bool else { return }
            self.window?.overrideUserInterfaceStyle = theme ? .light : .dark
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

