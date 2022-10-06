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
import Combine


struct ServerChargeStation: Codable {
    let metro: String
    let city: String
    let stnPlace: String
    let stnAddr: String
    let rapidCnt: Int
    let slowCnt: Int
    let carType: String
}


class ParseChargeStation : ObservableObject {
    static let shared = ParseChargeStation()
    private init() { }
    
    // Charge Station List
//    static var chargeStnList = [LocalChargeStation]()
    
//    @Published
    
    // Rx에서 BehaviorSubject, BehaviorRelay
    var chargeStnList = CurrentValueSubject<[LocalChargeStation], Never>([])
    
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
//                ParseChargeStation.chargeStnList = ParseChargeStation.shared.changeChargeStationData(from: result)
                let fetchedLocalCargeStations : [LocalChargeStation] = ParseChargeStation.shared.changeChargeStationData(from: result)
                
                //
                
                self.addCoordicatesToArray(to: fetchedLocalCargeStations, allDone: { [weak self] in
                    // 완성된 데이터 보내기
                    self?.chargeStnList.send($0)
                })
                
//                var finishLocalStations = fetchedLocalCargeStations
//
//                for (index, aStation) in fetchedLocalCargeStations.enumerated() {
//
//                    self.getCoordinate(aStation.stnAddr) { (location, error) in
//                        finishLocalStations[index].coordinate = [location.latitude, location.longitude]
//                        #if DEBUG
//                        print(#fileID, #function, #line, "- \(finishLocalStations[index].coordinate) \(finishLocalStations[index].stnAddr)")
//                        #endif
//                        // 완성된 데이터 보내기
//                        self.chargeStnList.send(finishLocalStations)
//                    }
//                }
                print(#fileID, #function, #line, "- \(self.chargeStnList.value.count)")
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
    
    
    private func addCoordicatesToArray(to array: [LocalChargeStation], allDone: (([LocalChargeStation]) -> Void)? = nil) {
        
        var tempArray = array
        
        var finishedArray : [LocalChargeStation] = []
        
        for (index, aStation) in array.enumerated() {
            
            self.getCoordinate(aStation.stnAddr) { (location, error) in
                tempArray[index].coordinate = [location.latitude, location.longitude]
                
                #if DEBUG
                print(#fileID, #function, #line, "- \(tempArray[index].coordinate) \(tempArray[index].stnAddr)")
                #endif
                
                // 하나에 대한 데이터 완성됨
                finishedArray.append(tempArray[index])
                
                // 모든 데이터가 준비되면 알리기
                if finishedArray.count == array.count {
                   allDone?(finishedArray)
                }
            }
            #warning("TODO : - 모든 데이터 준비되면 알리기")
        }
    }
    
    
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
