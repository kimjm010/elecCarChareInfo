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


// Model 수정할 것
/*
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
 
 */


// 차종 모델
struct CarType {
    let name: String
    var isSelected: Bool
}

// Option Model
struct Option {
    let optionName: String
    let optionImage: UIImage?
}


// 기본 충전소 데이터 모델
// TODO: 추후 변경할 예정
struct ChargeStation {
    let id: String
    let city: String
    let stnPlace: String
    let stnAddr: String
    let rapidCnt: Int
    let slowCnt: Int
    let coordinate: CLLocationCoordinate2D
    let carType: CarType
}


// dummy Data
// TODO: 추후 삭제 할 것
var dummyChargeStationData = [
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "LH강남힐스테이트",
                  stnAddr: "서울특별시 강남구 자곡동 자곡로3길 21",
                  rapidCnt: 1,
                  slowCnt: 4,
                  coordinate: CLLocationCoordinate2D(latitude: 37.5145037, longitude: 127.0410139),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "LH서울지사",
                  stnAddr: "서울특별시 강남구 선릉로 121길 12",
                  rapidCnt: 1,
                  slowCnt: 0,
                  coordinate: CLLocationCoordinate2D(latitude: 37.4831587, longitude: 127.0853829),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "가람아파트",
                  stnAddr: "서울특별시 강남구 일원동 일원로 127",
                  rapidCnt: 1,
                  slowCnt: 0,
                  coordinate: CLLocationCoordinate2D(latitude: 37.4718415, longitude: 127.0877141),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "강남구청 공영주차장",
                  stnAddr: "서울특별시 강남구 삼성동 16-1",
                  rapidCnt: 1,
                  slowCnt: 0,
                  coordinate: CLLocationCoordinate2D(latitude: 37.5175747, longitude: 127.0475074),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "강남데시앙파크",
                  stnAddr: "서울특별시 강남구 세곡동 헌릉로590길 63",
                  rapidCnt: 1,
                  slowCnt: 1,
                  coordinate: CLLocationCoordinate2D(latitude: 37.4610643, longitude: 127.1016045),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "강남데시앙포레",
                  stnAddr: "서울특별시 강남구 수서동 광평로34길55",
                  rapidCnt: 1,
                  slowCnt: 3,
                  coordinate: CLLocationCoordinate2D(latitude: 37.480856, longitude: 127.0921722),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false)),
    ChargeStation(id: UUID().uuidString,
                  city: "강남구",
                  stnPlace: "강남세브란스 병원",
                  stnAddr: "서울특별시 강남구 언주로 211",
                  rapidCnt: 2,
                  slowCnt: 0,
                  coordinate: CLLocationCoordinate2D(latitude: 37.4920496, longitude: 127.0463487),
                  carType: CarType(name: "SM3 Z.E,레이EV,소울EV,닛산리프,아이오닉EV,BMW i3,스파크EV,볼트EV,테슬라",
                                   isSelected: false))
]



