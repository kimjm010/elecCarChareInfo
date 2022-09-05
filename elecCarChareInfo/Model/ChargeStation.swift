//
//  ChargeStation.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/31/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct ChargeStation: Codable {
    
    var id: String
    var email: String?
    var city: String = ""
    var stnPlace: String
    var stnAddr: String
    var rapidCnt: Int
    var slowCnt: Int
    var coordinate: [Double]? = nil
    
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil  {
            if let dictionary = userDefaults.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    #if DEBUG
                    print("User Defuaults에서 유저 디코딩 중 에러 발생", #function, error.localizedDescription)
                    #endif
                }
            }
        }
        
        return nil
        
    }
}
