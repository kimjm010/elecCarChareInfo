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
    
    func registerMarkedChargeStation(user: User, station: ChargeStation, completion: @escaping (_ error: Error?) -> Void) {
        do {
//            try FirebaseReference(.marked).document(user.id).setData(from: station)
        } catch {
            print(error.localizedDescription, "파이어 스토어에 즐겨찾기 저장 시 에러 발생!")
        }
    }
}
