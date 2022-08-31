//
//  MarkedList.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/31/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct MarkedList: Codable {
    let id = ""
    let station: [String]
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.data(forKey: kCURRENTUSER) {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    #if DEBUG
                    print("UserDefaults에서 유저 디코딩 중 에럽 발생", #function, error.localizedDescription)
                    #endif
                }
            }
        }
        
        return nil
    }
}
