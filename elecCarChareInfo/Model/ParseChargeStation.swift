//
//  ParseChargeStation.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 10/3/22.
//

import Foundation
import Alamofire
import ProgressHUD
import CoreLocation


struct TempChargeStn: Codable {
    let metro: String
    let city: String
    let stnPlace: String
    let stnAddr: String
    let rapidCnt: Int
    let slowCnt: Int
    let carType: String
}


class ParseChargeStation {
    static let shared = ParseChargeStation()
    private init() { }
    
    static var chargeStnList = [ChargeStation]()
    
    private let urlStr = "http://localhost:3000/data/"
    
    // MARK: - Parse data From Server
    
    func parseData(completion: @escaping (_ result: Data) -> Void) {
        AF.request(urlStr).response { (response) in
            switch response.result {
            case .success(let data):
                completion(data!)
            case .failure(let error):
                ProgressHUD.showFailed("Fail to parse data From server.\n Please try it again.\n \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Store the changed data to ParseChargeStation.chargeStnList
    
    func changeData() {
        ParseChargeStation.shared.parseData { (data) in
            do {
                let result = try JSONDecoder().decode([TempChargeStn].self, from: data)
                ParseChargeStation.chargeStnList = ParseChargeStation.shared.changeChargeStationData(from: result)
                
            } catch {
                ProgressHUD.showFailed("Cannot fetch Data from Server.\n Please try again later.")
            }
        }
    }
    
    
    // MARK: - Change Data Type to ChargeStation Array
    
    private func changeChargeStationData(from originalData: [TempChargeStn]) -> [ChargeStation] {
        var stationList = [ChargeStation]()
        
        for i in 0..<originalData.count {
            let original = originalData[i]
            let chargeStation = ChargeStation(id: UUID().uuidString,
                                              city: original.city,
                                              stnPlace: original.stnPlace,
                                              stnAddr: original.stnAddr,
                                              rapidCnt: original.rapidCnt,
                                              slowCnt: original.slowCnt)
            stationList.append(chargeStation)
        }

        return stationList
    }
}
