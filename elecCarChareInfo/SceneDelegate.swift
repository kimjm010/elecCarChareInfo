//
//  SceneDelegate.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import UIKit
import FirebaseAuth
import ProgressHUD


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Vars
    
    var window: UIWindow?
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Scene Delegate Functions

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)  {
        autoLogin()
        guard let _ = (scene as? UIWindowScene) else { return }
        
        ParseChargeStation.shared.changeData()
        
        
//        ParseChargeStation.shared.parseData { (data) in
//            
//            print(#fileID, #function, #line, "- \(data)")
//            do {
//                let result = try JSONDecoder().decode(ChargeStation.self, from: data)
//            } catch {
//                ProgressHUD.showFailed("Unable to fetch charge information data from server.\n Please try it again.")
//            }
//        }
    }

    
    // MARK: - Auto Login
    
    func autoLogin() {
        authListener = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            guard let self = self else { return }
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil  && userDefaults.object(forKey: kCURRENTUSER) != nil {
                
                DispatchQueue.main.async {
                    self.gotoAppMain()
                }
            }
        })
    }
    
    
    // MARK: - Go to Main View
    
    private func gotoAppMain() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
        
        self.window?.rootViewController = mainVC
    }
}

