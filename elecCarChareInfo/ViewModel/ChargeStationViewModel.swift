//
//  ChargeStationViewModel.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 10/21/22.
//

import Foundation
import MapKit
import UIKit


class ChargeStationViewModel {
    
    // MARK: - User Location 권한 확인
    
    /// Check User Location Authorization
    ///
    /// - Returns: Location Authorization Status
    func checkLocationAuthorization() -> CLAuthorizationStatus? {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            status = CLLocationManager().authorizationStatus
            
            switch status {
            case .notDetermined:
                CLLocationManager().requestWhenInUseAuthorization()
            case .restricted:
                return CLAuthorizationStatus.restricted
            case .denied:
                return CLAuthorizationStatus.denied
            case .authorizedWhenInUse, .authorizedAlways:
                updateLocation()
                
            default:
                break
            }
        }
        
        return nil
    }
    
    
    // MARK: - Go To Current Location
    
    /// Move the center to current Location
    ///
    /// - Returns: Current Coordinate Region
    func goToCurrentLocation() -> MKCoordinateRegion? {
        
        guard let initCntrCoordinate = CLLocationManager().location?.coordinate else { return nil }
        let region = MKCoordinateRegion(center: initCntrCoordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        return region
    }
    
    
    // MARK: - Start Updating User Location
    
    /// Start Updating User Location
    func updateLocation() {
        CLLocationManager().startUpdatingLocation()
    }
    
    
    /// Inform To ViewModel when the user change the location authorizationStatus
    ///
    /// - Returns: Location Authorization Status
    func changeLocationAuthorization() -> CLAuthorizationStatus? {
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
            return nil
        default:
            return CLLocationManager().authorizationStatus
        }
    }
    
    
    /// Show Error Message when fail to get user location
    ///
    /// - Parameter completion: conduct after stop updating location
    func showError(completion: () -> Void) {
        CLLocationManager().stopUpdatingLocation()
        completion()
    }
    
    
    // MARK: - Set Markers to Map View
    
    /// Create Annotation Markers and Return
    ///
    /// - Parameter markersPoints: Local Charge Station Array
    /// - Returns: Charge Annotation Array
    func setAnnotationMarkers(_ markersPoints: [LocalChargeStation]) -> [ChargeAnnotation] {
        let annotations: [ChargeAnnotation] = markersPoints.map { (charge) in
            guard let coordinates = charge.coordinate else {
                return ChargeAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                        identity: charge.identity,
                                        title: charge.stnPlace,
                                        subtitle: charge.stnAddr,
                                        city: charge.city,
                                        rapidCnt: charge.rapidCnt,
                                        slowCnt: charge.slowCnt)
            }
            return ChargeAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates[0],
                                                                       longitude: coordinates[1]),
                                    identity: charge.identity,
                                    title: charge.stnPlace,
                                    subtitle: charge.stnAddr,
                                    city: charge.city,
                                    rapidCnt: charge.rapidCnt,
                                    slowCnt: charge.slowCnt)
        }
        
        return annotations
    }
}
