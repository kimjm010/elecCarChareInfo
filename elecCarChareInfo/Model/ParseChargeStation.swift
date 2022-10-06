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


struct ServerChargeStation: Codable {
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
    
    // Charge Station List
    static var chargeStnList = [LocalChargeStation]()
    
    private let urlStr = "https://eleccar-charge-station.herokuapp.com/data"
    
    // MARK: - Parse data From Server
    
    func parseData(completion: @escaping (_ result: Data) -> Void) {
        
        AF.request(urlStr).response { (response) in
            switch response.result {
            case .success(let data):
                completion(data!)
            case .failure(let error):
                ProgressHUD.showFailed("Fail to parse data From server.\n Please try it again.\n \(error.localizedDescription)")
                print(#fileID, #function, #line, "- \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Store the changed data to ParseChargeStation.chargeStnList
    
    func changeData() {
        ParseChargeStation.shared.parseData { [weak self] (data) in
            guard let self = self else { return }
            
            do {
                let result = try JSONDecoder().decode([ServerChargeStation].self, from: data)
                ParseChargeStation.chargeStnList = ParseChargeStation.shared.changeChargeStationData(from: result)
                
                for i in 0..<ParseChargeStation.chargeStnList.count {
                    self.getCoordinate(ParseChargeStation.chargeStnList[i].stnAddr) { (location, error) in
                        ParseChargeStation.chargeStnList[i].coordinate = [location.latitude, location.longitude]
                        
                        #if DEBUG
                        print(#fileID, #function, #line, "- \(ParseChargeStation.chargeStnList[i].coordinate) \(ParseChargeStation.chargeStnList[i].stnAddr)")
                        #endif
                    }
                }
                
                print(#fileID, #function, #line, "- \(ParseChargeStation.chargeStnList.count)")
            } catch {
                ProgressHUD.showFailed("Cannot fetch Data from Server.\n Please try again later.")
            }
        }
    }
    
    
    // MARK: - Change Data Type to ChargeStation Array
    
    private func changeChargeStationData(from originalData: [ServerChargeStation]) -> [LocalChargeStation] {
        var stationList = [LocalChargeStation]()
        
        for i in 0..<originalData.count {
            let original = originalData[i]
            let chargeStation = LocalChargeStation(id: UUID().uuidString,
                                                   city: original.city,
                                                   stnPlace: original.stnPlace,
                                                   stnAddr: original.stnAddr,
                                                   rapidCnt: original.rapidCnt,
                                                   slowCnt: original.slowCnt)
            stationList.append(chargeStation)
        }
        
        return stationList
    }
    
    
    // MARK: - Convert Placemark into Coordinate
    
    /// 주소를 Coordinate 객체로 변환하는 메소드
    /// - Parameters:
    ///   - addressString: 변환할 주소
    ///   - completion: 변환 성공 시 (CLLocationCoordinate2D, NSError?)을 담은 completion handler가 호출됨
    private func getCoordinate(_ addressString: String, completion: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                    return
                }
            }
            
            completion(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
