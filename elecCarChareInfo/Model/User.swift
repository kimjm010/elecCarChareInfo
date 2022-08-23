//
//  User.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/12/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable, Equatable {
    var id = ""
    var email: String
    var pushId = ""
    
    /// 현재 로그인 된 User의 id를 리턴
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    /// 
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    #if DEBUG
                    print("User Defaults에서 유저 디코딩 중 에러 발생했습니다", #function, error.localizedDescription)
                    #endif
                }
            }
        }
        
        return nil
    }
    
    
    /// 유저가 서로 같은이 확인
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}



// MARK: - User 객체를 UserDefaults에 저장하기
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
