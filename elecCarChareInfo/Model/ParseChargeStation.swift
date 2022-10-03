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
    
    // #1 data 가져와서 Charge Station으로 변환하기
    
    func parseData(completion: @escaping (_ result: Data) -> Void) {
        AF.request(urlStr).response { (response) in
            switch response.result {
            case .success(let data):
                completion(data!)
                print(#fileID, #function, #line, "- ")
            case .failure(let error):
                ProgressHUD.showFailed("Fail to parse data From server.\n Please try it again.")
            }
        }
    }
    
    
    func tempChangeData() {
        ParseChargeStation.shared.parseData { [weak self] (data) in
            guard let self = self else { return }
            
            do {
                let result = try JSONDecoder().decode([TempChargeStn].self, from: data)
                
                
                // #2 Coordination 추가해서 ChargeStationModel로 변환
                let newdata = ParseChargeStation.shared.changeChargeStationData(from: result)
                
                for i in 0..<newdata.count {
                    print(#fileID, #function, #line, "- \(newdata[i].stnAddr)")
                }
            } catch {
                print(#fileID, #function, #line, "- \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Change ChargeStation Model
    
    private func changeChargeStationData(from originalData: [TempChargeStn]) -> [ChargeStation] {
        var stationList = [ChargeStation]()
        var location = [0.0, 0.0]
        
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
