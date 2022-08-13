//
//  ChargeStationModel.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


struct ChargeStation: Codable {
    struct Data: Codable {
        let metro: String
        let city: String
        let stnPlace: String
        let stnAddr: String
        let rapidCnt: Int
        let slowCnt: Int
        let carType: String
    }
    
    let data: [Data]
}



struct ChargeStn: Codable {
    var id = ""
    
    let chargeStn: ChargeStation.Data
    
    let latitude: Double
    
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var annotation: MKAnnotation {
        return ChargeStnAnnotation(coordinate: coordinate,
                                   stnId: id,
                                   title: chargeStn.stnPlace,
                                   subtitle: chargeStn.stnAddr)
    }
}


struct Option {
    let optionName: String
    let optionImage: UIImage?
}









// dummy data
var dummyChargeStation = [
    ChargeStn(id: "1",
              chargeStn: ChargeStation.Data(metro: "서울특별시",
                                            city: "강남구",
                                            stnPlace: "LH강남힐스테이트",
                                            stnAddr: "서울특별시 강남구 자곡동 자곡로3길 21",
                                            rapidCnt: 1,
                                            slowCnt: 4,
                                            carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라"),
              latitude: 37.5145037,
              longitude: 127.0410139),
    ChargeStn(id: "1",
              chargeStn: ChargeStation.Data(metro: "서울특별시",
                                            city: "강남구",
                                            stnPlace: "LH서울지사",
                                            stnAddr: "서울특별시 강남구 선릉로 121길 12",
                                            rapidCnt: 1,
                                            slowCnt: 0,
                                            carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라"),
              latitude: 37.4831587,
              longitude: 127.0853829),
    ChargeStn(id: "1",
              chargeStn: ChargeStation.Data(metro: "서울특별시",
                                            city: "강남구",
                                            stnPlace: "가람아파트",
                                            stnAddr: "서울특별시 강남구 일원동 일원로 127",
                                            rapidCnt: 1,
                                            slowCnt: 0,
                                            carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라"),
              latitude: 37.4718415,
              longitude: 127.0877141),
]


var tempDummyChargeStn = [
    TempChargeStn(metro: "서울특별시",
                  city: "강남구",
                  stnPlace: "LH강남힐스테이트",
                  stnAddr: "서울특별시 강남구 자곡동 자곡로3길 21",
                  rapidCnt: 1,
                  slowCnt: 4,
                  carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                  coordinate: CLLocationCoordinate2D(latitude: 37.5145037, longitude: 127.0410139)),
    TempChargeStn(metro: "서울특별시",
                  city: "강남구",
                  stnPlace: "LH서울지사",
                  stnAddr: "서울특별시 강남구 선릉로 121길 12",
                  rapidCnt: 1,
                  slowCnt: 0,
                  carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                  coordinate: CLLocationCoordinate2D(latitude: 37.4831587, longitude: 127.0853829)),
    TempChargeStn(metro: "서울특별시",
                  city: "강남구",
                  stnPlace: "LH강남힐스테이트",
                  stnAddr: "서울특별시 강남구 자곡동 자곡로3길 21",
                  rapidCnt: 1,
                  slowCnt: 4,
                  carType: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                  coordinate: CLLocationCoordinate2D(latitude: 37.4718415, longitude: 127.0877141)),
]


              
              
              
              
              
              
              
              
              
              
