//
//  ChargeAnnotation.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/14/22.
//

import Foundation
import MapKit


class ChargeAnnotation: NSObject, MKAnnotation {
    
    /// 좌표 데이터
    @objc
    dynamic var coordinate: CLLocationCoordinate2D
    
    /// 표시한 충전소 식별 id
    var id: String
    
    /// annotation 제목
    ///
    /// Charge Station의 이름
    var title: String?
    
    /// annotation 부제목
    ///
    /// Charge Station의 주소
    var subtitle: String?
    
    var city: String?
    
    var rapidCnt: Int?
    
    var slowCnt: Int?
    
    var carType: String?
    
    
    init(coordinate: CLLocationCoordinate2D,
         id: String,
         title: String?,
         subtitle: String?,
         city: String?,
         rapidCnt: Int?,
         slowCnt: Int?,
         carType: String?) {
        self.coordinate = coordinate
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.city = city
        self.rapidCnt = rapidCnt
        self.slowCnt = slowCnt
        self.carType = carType
    }
}