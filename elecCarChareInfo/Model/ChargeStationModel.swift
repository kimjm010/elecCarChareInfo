//
//  ChargeStationModel.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import Foundation
import UIKit
import CoreLocation


#warning("Todo: - 추후 삭제 할 것")
var dummyChargeStationData = [
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "LH강남힐스테이트",
                       stnAddr: "서울특별시 강남구 자곡동 자곡로3길 21",
                       rapidCnt: 1,
                       slowCnt: 4,
                       coordinate: [37.5145037, 127.0410139]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "LH서울지사",
                       stnAddr: "서울특별시 강남구 선릉로 121길 12",
                       rapidCnt: 1,
                       slowCnt: 0,
                       coordinate: [37.4831587, 127.0853829]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "가람아파트",
                       stnAddr: "서울특별시 강남구 일원동 일원로 127",
                       rapidCnt: 1,
                       slowCnt: 0,
                       coordinate: [37.4718415, 127.0877141]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "강남구청 공영주차장",
                       stnAddr: "서울특별시 강남구 삼성동 16-1",
                       rapidCnt: 1,
                       slowCnt: 0,
                       coordinate: [37.5175747, 127.0475074]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "강남데시앙파크",
                       stnAddr: "서울특별시 강남구 세곡동 헌릉로590길 63",
                       rapidCnt: 1,
                       slowCnt: 1,
                       coordinate: [37.4610643, 127.1016045]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "강남데시앙포레",
                       stnAddr: "서울특별시 강남구 수서동 광평로34길55",
                       rapidCnt: 1,
                       slowCnt: 3,
                       coordinate: [37.480856, 127.0921722]),
    LocalChargeStation(id: UUID().uuidString,
                       city: "강남구",
                       stnPlace: "강남세브란스 병원",
                       stnAddr: "서울특별시 강남구 언주로 211",
                       rapidCnt: 2,
                       slowCnt: 0,
                       coordinate: [37.4920496, 127.0463487])
]

