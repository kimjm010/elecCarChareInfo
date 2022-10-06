//
//  FirebaseMarked.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/31/22.
//

import Foundation
import Firebase
import ProgressHUD


class FirebaseMarked {
    
    static let shared = FirebaseMarked()
    private init() { }
    
    
    // MARK: - Add Marked
    
    func saveChargeStationToFirebase(user: User,
                                     station: LocalChargeStation) {
        do {
            try FirebaseReference(.marked).document(station.id).setData(from: station)
        } catch {
            ProgressHUD.showFailed("Unable to save Charge Station into your marked list.\n Please try it again later.")
        }
    }
    
    
    // MARK: - Register Marked Charge Station
    
    func registerChargeStation(email: String,
                               city: String,
                               stnPlace: String,
                               stnAddr: String,
                               rapidCnt: Int,
                               slowCnt: Int,
                               coordinate: [Double],
                               completion: @escaping (_ error: Error?) -> Void) {
        guard let user = User.currentUser else { return }
        
        let chargeStation = LocalChargeStation(id: UUID().uuidString,
                                          email: email,
                                          city: city,
                                          stnPlace: stnPlace,
                                          stnAddr: stnAddr,
                                          rapidCnt: rapidCnt,
                                          slowCnt: slowCnt,
                                          coordinate: coordinate)
        completion(nil)
        saveChargeStationToFirebase(user: user, station: chargeStation)
    }
}
