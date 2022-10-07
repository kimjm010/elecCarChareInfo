//
//  ChargeStation.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/31/22.
//

import FirebaseFirestoreSwift
import ProgressHUD
import Foundation
import Firebase


struct LocalChargeStation: Codable, Comparable {
    
    var identity: String
    var email: String?
    var city: String = ""
    var stnPlace: String
    var stnAddr: String
    var rapidCnt: Int
    var slowCnt: Int
    var coordinate: [Double]? = nil
    
    
    static func < (lhs: LocalChargeStation, rhs: LocalChargeStation) -> Bool {
        return lhs.stnPlace < rhs.stnPlace
    }
    
    
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
                    ProgressHUD.showFailed("Error occurred while decoding from User Defaults.\n Please try application later.")
                }
            }
        }
        
        return nil
    }
}
