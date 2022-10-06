//
//  MarkedList.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/31/22.
//

import FirebaseFirestoreSwift
import ProgressHUD
import Foundation
import Firebase


struct MarkedList: Codable {
    var id = ""
    var station: [String]
    
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
                    ProgressHUD.showFailed("Error occurred while decoding from User Defaults.\n Please try application later.")
                }
            }
        }
        
        return nil
    }
}
