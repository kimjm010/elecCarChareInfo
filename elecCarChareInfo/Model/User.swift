//
//  User.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import FirebaseFirestoreSwift
import ProgressHUD
import Foundation
import Firebase


struct User: Codable, Equatable {
    var id = ""
    var email: String
    
    /// 현재 로그인 된 User의 id를 리턴
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    /// 현재 로그인 된 User를 UserDefaults에 저장하고 User객체를 디코딩함
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
    
    
    /// 같은 유저인지 확인
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}



// MARK: - User 객체를 UserDefaults에 저장합니다.

func saveUserLocally(_ user: User) {
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
        #if DEBUG
        print("유저 인코딩 중 에러 발생", #function, error.localizedDescription)
        #endif
    }
}
