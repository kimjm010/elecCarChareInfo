//
//  ChargeStationViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//


import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import NSObject_Rx
import RxSwift
import MapKit
import UIKit


class ChargeStationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enterPlaceButton: UIButton!
    @IBOutlet weak var goToCurrentLocationButton: UIButton!
    
    
    // MARK: - Vars
    
    private var selectedChargeStation: LocalChargeStation?
    private var selectedAnnotation: MKAnnotation?
    private var calculatedDistance: Double = 0.0
    private var userLocation: CLLocationCoordinate2D?
    private var allAnnotations: [MKAnnotation]?
    private var ref: DatabaseReference!
    
    /// CLLocationManager 관리 객체
    lazy var locationManager: CLLocationManager = { [weak self] in
        let m = CLLocationManager()
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        return m
    }()
    
    
    // MARK: - IBActions
    
    /// 현재 위치로 이동합니다.
    /// - Parameter sender: 현재 위치 버튼
    @IBAction func goToCurrentLocation(_ sender: Any) {
        goToCurrentLocation()
    }
    
    
    /// 특정 위치를 검색합니다.
    /// - Parameter sender: enterPlaceButton
    @IBAction func placeButtonTapped(_ sender: Any) {
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchTableViewController")
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        goToCurrentLocation()
        initializeMapView()
        registerMapAnnotationViews()
        setTabBarAppearanceAsDefault()
        updateBtnUI()
        
        ParseChargeStation.shared.chargeStnListObservable
            .filter { $0.count > 0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setMarkers($0)
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - Initialize Data
    
    private func initializeData() {
        goToCurrentLocationButton.setTitle("", for: .normal)
        goToCurrentLocationButton.setEnableBtnTheme()
        mapView.showsCompass = false
    }
    
    
    // MARK: - Button UI Update
    
    private func updateBtnUI() {
        enterPlaceButton.setTitle("Please Enter Region / Station Name", for: .normal)
        enterPlaceButton.titleLabel?.textColor = UIColor.systemGray
        enterPlaceButton.layer.cornerRadius = 10
    }
    
    
    // MARK: - MapView Initial Setting
    
    private func initializeMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    
    // MARK: - Go To Current Location
    
    private func goToCurrentLocation() {
        
        guard let initCntrCoordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: initCntrCoordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    
    // MARK: - User Location 권한 확인
    
    /// User's Location Authorization확인
    private func checkLocationAuth() {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            status = self.locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                self.alertLocationAuth(title: "위치 권한이 제한되어있습니다.",
                                       message: "설정으로 이동하여 위치 권한을 변경하시겠습니까?",
                                       completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                self.updateLocation()
            default:
                break
            }
        }
    }
    
    
    
    
    // MARK: - Annotation Views
    
    /// 지도에서 사용할 annotation View 타입을 등록합니다.
    private func registerMapAnnotationViews() {
        mapView.register(MKAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(ChargeAnnotation.self))
    }
    
    
    // MARK: - Set Markers to Map View
    
    /// 맵에 마커를 찍는다
    /// - Parameter markerPoints: 찍을 마킹 포인트들
    private func setMarkers(_ markerPoints : [LocalChargeStation]){
        
        let annotations: [ChargeAnnotation] = markerPoints.map { (charge) in
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
        
        mapView.addAnnotations(annotations)
    }
    
    
    // MARK: - Add Route
    
    /// 특정 충전소가까지의 Route를 제공합니다.
    /// - Parameter coordinate: 충전소 위치
    private func addRoute(to coordinate: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
#if DEBUG
                print(error.localizedDescription, "Add Route response에서 에러 발생")
#endif
                return
            }
            
            if let response = response {
                let lines = MKMultiPolyline(response.routes.map { $0.polyline })
                
                self.mapView.addOverlay(lines)
                
                self.mapView.setVisibleMapRect(lines.boundingMapRect,
                                               edgePadding: UIEdgeInsets(top: 100,
                                                                         left: 100,
                                                                         bottom: 100,
                                                                         right: 100),
                                               animated: true)
                
                guard let distance = response.routes.first?.distance else { return }
                self.calculatedDistance = round(distance / 1000)
            }
        }
    }
    
    
    // MARK: - Remove Route
    
    /// 특정 충전소까지의 Route를 취소합니다.
    private func removeRoute() {
        mapView.removeOverlays(mapView.overlays)
    }
}




// MARK: - CLLocationManager Delegate

extension ChargeStationViewController: CLLocationManagerDelegate {
    
    /// 위치 업데이트를 시작합니다.
    func updateLocation() {
        locationManager.startUpdatingHeading()
    }
    
    
    /// 위치 사용 권한 변경 시 호출됩니다.
    /// - Parameter manager: locationManager 객체
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            updateLocation()
        default:
            alertLocationAuth(title: "위치 권한이 제한되어있습니다.",
                              message: "설정으로 이동하여 위치 권한을 변경하시겠습니까?") { [weak self] _ in
                guard let self = self else { return }
                print(#fileID, #function, #line, "- ")
                self.checkLocationAuth()
            }
        }
    }
    
    
    /// 위치 검색 실패 시 알림창을 띄웁니다.
    /// - Parameters:
    ///   - manager: location manager 객체
    ///   - error: error 객체
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingHeading()
        
        alertLocationAuth(title: "사용자의 위치를 확인 할 수 없습니다.",
                          message: "설정에서 위치 서비스를 허용 하시겠습니까?",
                          completion: nil)
    }
    
    
    /// 사용자의 위치가 업데이틑 경우 호출하는 메소드,
    /// - Parameters:
    ///   - manager: locationManager 객체
    ///   - locations: 업데이트된 위치 배열
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let current = locations.last {
            
            let region = MKCoordinateRegion(center: current.coordinate,
                                            latitudinalMeters: 20,
                                            longitudinalMeters: 20)
            
            mapView.setRegion(region, animated: true)
        }
    }
}




// MARK:  - MKMapView Delegate

extension ChargeStationViewController: MKMapViewDelegate {
    
    /// Annotation View를 tap했을 때 이벤트가 전달됩니다.
    /// - Parameters:
    ///   - mapView: annotation 표시한 mapView
    ///   - view: 선택 된 MKAnnotationView 객체
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        enterPlaceButton.titleLabel?.text = annotation?.title ?? ""
        enterPlaceButton.titleLabel?.tintColor = .label
        enterPlaceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        addRoute(to: annotation!.coordinate)
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeRoute()
        updateBtnUI()
    }
    
    
    /// ChargeStation Annotation View를 리턴합니다.
    /// - Parameters:
    ///   - mapView: annotation 표시할 mapView
    ///   - annotation: MKAnnotation 객체
    /// - Returns: MKAnnotationView객체
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // annotation이 MKUserLocation인 경우는 customize 하지 않음.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        // TODO: mapView에 비슷한 위치에 있는 충전소는 갯수로 표시하기
        
        if let annotation = annotation as? MKClusterAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier,
                                                             for: annotation) as! MKMarkerAnnotationView
            
            view.markerTintColor = UIColor.systemBlue
        }
        
        if let annotation = annotation as? ChargeAnnotation {
            annotationView = setupChargeStnAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    
    /// 지도에 표시할 annotation View를 제공합니다.
    ///
    /// - Parameters:
    ///   - annotation: annotation
    ///   - mapView: annotation 표시할 mapView
    /// - Returns: annotationView
    private func setupChargeStnAnnotationView(for annotation: ChargeAnnotation,
                                              on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(ChargeAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier,
                                                         for: annotation)
        
        let image = #imageLiteral(resourceName: "chargeStn")
        view.image = image
        
        let rightButton = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = rightButton
        
        view.canShowCallout = true
        
        return view
    }
    
    
    /// callout이 tap되었을 때 충전소 정보를 화면에 표시합니다.
    ///
    /// - Parameters:
    ///   - mapView: annotation View가 표시된 mapView
    ///   - view: callout의 annotation View
    ///   - control: tap 이벤트가 발생한 컨트롤
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation, annotation.isKind(of: ChargeAnnotation.self) {
            
            if let chargeAnnotation = annotation as? ChargeAnnotation {
                guard let city = chargeAnnotation.city,
                      let stnPlace = chargeAnnotation.title,
                      let stnAddr = chargeAnnotation.subtitle,
                      let rapidCnt = chargeAnnotation.rapidCnt,
                      let slowCnt = chargeAnnotation.slowCnt else { return }
                selectedAnnotation = chargeAnnotation
                selectedChargeStation = LocalChargeStation(identity: chargeAnnotation.identity,
                                                           city: city,
                                                           stnPlace: stnPlace,
                                                           stnAddr: stnAddr,
                                                           rapidCnt: rapidCnt,
                                                           slowCnt: slowCnt,
                                                           coordinate: [chargeAnnotation.coordinate.latitude,
                                                                        chargeAnnotation.coordinate.longitude])
            }
            
            if let infoVC = storyboard?.instantiateViewController(withIdentifier: "ChargeStnInfoViewController") as? ChargeStnInfoViewController {
                
                infoVC.chargeStn = selectedChargeStation
                infoVC.annotation = selectedAnnotation
                infoVC.calculatedDistance = calculatedDistance
                infoVC.userLocation = locationManager.location?.coordinate
                infoVC.modalPresentationStyle = .popover
                
                let presentationController = infoVC.popoverPresentationController
                presentationController?.permittedArrowDirections = .any
                presentationController?.sourceRect = control.frame
                presentationController?.sourceView = control
                
                present(infoVC, animated: true, completion: nil)
            }
        }
    }
    
    
    /// 목적지까지의 overlay를 그리는 메소드
    /// - Parameters:
    ///   - mapView: render객체를 요청한 mapView
    ///   - overlay: 화면에 표시할 overlay객체
    /// - Returns: 화면에 표시할 render
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKMultiPolyline {
            let r = MKMultiPolylineRenderer(overlay: overlay)
            r.lineWidth = 5
            r.strokeColor = UIColor.systemBlue
            
            return r
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
}
