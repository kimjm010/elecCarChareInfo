//
//  Comment.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/26/22.
//

import FirebaseFirestoreSwift
import ProgressHUD
import Foundation
import Firebase


struct Comment: Codable {
    var id = ""
    var email = ""
    var comment = ""
    var date = ""
    
    /// 현재 로그인 된 User의 id를 리턴
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    
    /// 현재 로그인 된 User를 UserDefaults에 저장하고  Comment객체를 디코딩함
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    ProgressHUD.showFailed("Error occurred while decoding from User Defaults.\n Please try application later.")
                }
            }
        }
        
        return nil
    }
}
