//
//  ParseChargeStation.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 10/3/22.
//

import CoreLocation
import NSObject_Rx
import RxAlamofire
import ProgressHUD
import RxSwift


struct ServerChargeStation: Codable {
    let metro: String
    let city: String
    let stnPlace: String
    let stnAddr: String
    let rapidCnt: Int
    let slowCnt: Int
    let carType: String
}


enum APIError: Error {
    case badResponse
}


class ParseChargeStation : ObservableObject {
    static let shared = ParseChargeStation()
    private init() { }
    
    // MARK: - Vars
    
    var chargeStnListObservable = BehaviorSubject<[LocalChargeStation]>(value: [])
    
    private let urlStr = "https://eleccar-charge-station.herokuapp.com/data"
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Parse data From Server

    func rxParseData(completion: @escaping (_ ressult: Data) -> Void) {
        RxAlamofire.requestData(.get, urlStr)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $1 }
            .subscribe(onNext: {
                completion($0)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Store the changed data to ParseChargeStation.chargeStnList
    
    func changeData() {
        
        ParseChargeStation.shared.rxParseData { [weak self] (data) in
            guard let self = self else { return }
            
            do {
                let result = try JSONDecoder().decode([ServerChargeStation].self, from: data)
                
                let fetchedLocalCargeStations : [LocalChargeStation] = ParseChargeStation.shared.changeChargeStationData(from: result)
                
                self.addCoordinatesToArray(to: fetchedLocalCargeStations) { [weak self] in
                    guard let self = self else { return }
                    
                    self.chargeStnListObservable.onNext($0)
                }
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
            let chargeStation = LocalChargeStation(identity: UUID().uuidString,
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
    
    /// ????????? ????????? ????????? ?????? ?????? ??????
    /// - Parameters:
    ///   - array: ????????? ????????? ??????
    ///   - allDone: ?????? ?????? ?????? ??? ????????? ??????
    private func addCoordinatesToArray(to array: [LocalChargeStation], allDone: (([LocalChargeStation]) -> Void)? = nil) {
        
        var tempArray = array
        
        var finishedArray : [LocalChargeStation] = []
        
        for (index, aStation) in array.enumerated() {
            
            self.getCoordinate(aStation.stnAddr) { (location, error) in
                tempArray[index].coordinate = [location.latitude, location.longitude]
                
                // ????????? ?????? ????????? ?????????
                finishedArray.append(tempArray[index])
                
                // ?????? ???????????? ???????????? ?????????
                if finishedArray.count == array.count {
                   allDone?(finishedArray)
                }
            }
        }
    }
    
    
    /// ????????? Coordinate ????????? ???????????? ?????????
    /// - Parameters:
    ///   - addressString: ????????? ??????
    ///   - completion: ?????? ?????? ??? (CLLocationCoordinate2D, NSError?)??? ?????? completion handler??? ?????????
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
