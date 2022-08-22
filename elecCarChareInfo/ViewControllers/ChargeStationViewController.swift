//
//  ChargeStationViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import UIKit
import CoreLocation
import MapKit


class ChargeStationViewController: UIViewController {
    
    // MARK: - Vars
    
    var selectedChargeStation: ChargeStation?
    
    var selectedAnnotation: MKAnnotation?
    
    var calculatedDistance: Double = 0.0
    
    var userLocation: CLLocationCoordinate2D?
    
    var isDarkMode: Bool = false
    
    /// CLLocationManager 관리 객체
    lazy var locationManager: CLLocationManager = { [weak self] in
        let m = CLLocationManager()
        
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        
        return m
    }()
    
    private var allAnnotations: [MKAnnotation]?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var enterPlaceButton: UIButton!
    
    @IBOutlet weak var goToCurrentLocationButton: UIButton!
    
    // options 배열
    var options = [
        Option(optionName: "Filter", optionImage: UIImage(systemName: "slider.horizontal.3")),
        Option(optionName: "Show Specific Station", optionImage: UIImage(systemName: "slider.horizontal.3")),
        Option(optionName: "I'm Filter's friend", optionImage: UIImage(systemName: "slider.horizontal.3"))
    ]
    
    
    // MARK: - IBActions
    
    /// 현재 위치로 이동합니다.
    /// - Parameter sender: 현재 위치 버튼
    @IBAction func goToCurrentLocation(_ sender: Any) {
        goToCurrentLocation()
    }
    
    
    /// 특정 위치를 검색합니다.
    /// - Parameter sender: enterPlaceButton
    @IBAction func placeButtonTapped(_ sender: Any) {
        let serchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchTableViewController")
        navigationController?.pushViewController(serchVC, animated: true)
    }
    
    
    
    // MARK: - View Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        goToCurrentLocation()
        
        checkLocationAuth()
        
        initializeMapView()
        
        registerMapAnnotationViews()
        
    }
    
    
    // MARK: - Initialize Data
    
    private func initializeData() {
        goToCurrentLocationButton.setTitle("", for: .normal)
        goToCurrentLocationButton.setEnableBtnTheme()
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
         print(initCntrCoordinate.latitude, initCntrCoordinate.longitude)
         let region = MKCoordinateRegion(center: initCntrCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
         mapView.setRegion(region, animated: true)
    }
    
    
    // MARK: - User Location 권한 확인
    
    /// User's Location Authorization확인
    private func checkLocationAuth() {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            
            status = locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                alertLocationAuth(title: "위치 권한이 제한되어있습니다.",
                                  message: "설정으로 이동하여 위치 권한을 변경하시겠습니까?",
                                  completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                updateLocation()
            default:
                break
            }
        }
    }
    
    
    // MARK: - Annotation Views
    
    /// 지도에서 사용할 annotation View 타입을 등록합니다.
    private func registerMapAnnotationViews() {
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ChargeAnnotation.self))
        
        let annotations: [ChargeAnnotation] = dummyChargeStationData.map { (charge) in
            return ChargeAnnotation(coordinate: charge.coordinate,
                                    id: charge.id,
                                    title: charge.stnPlace,
                                    subtitle: charge.stnAddr,
                                    city: charge.city,
                                    rapidCnt: charge.rapidCnt,
                                    slowCnt: charge.slowCnt,
                                    carType: charge.carType)
        }
        
        mapView.addAnnotations(annotations)
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
                              message: "설정으로 이동하여 위치 권한을 변경하시겠습니까?",
                              completion: nil)
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




// MARK:  - MKMapViewDelegate

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
    private func setupChargeStnAnnotationView(for annotation: ChargeAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(ChargeAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation, annotation.isKind(of: ChargeAnnotation.self) {
            
            if let chargeAnnotation = annotation as? ChargeAnnotation {
                guard let city = chargeAnnotation.city,
                      let stnPlace = chargeAnnotation.title,
                      let stnAddr = chargeAnnotation.subtitle,
                      let rapidCnt = chargeAnnotation.rapidCnt,
                      let slowCnt = chargeAnnotation.slowCnt,
                      let carType = chargeAnnotation.carType else { return }
                selectedAnnotation = chargeAnnotation
                selectedChargeStation = ChargeStation(id: chargeAnnotation.id,
                                                      city: city,
                                                      stnPlace: stnPlace,
                                                      stnAddr: stnAddr,
                                                      rapidCnt: rapidCnt,
                                                      slowCnt: slowCnt,
                                                      coordinate: chargeAnnotation.coordinate,
                                                      carType: carType)
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




// MARK: - UICollectionView DataSource

extension ChargeStationViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OptionsCollectionViewCell
        
        cell.configure(option: options[indexPath.item]) {
            cell.optionImageView.image = options[indexPath.item].optionImage
        }
        
        return cell
    }
}




extension ChargeStationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = vc.instantiateViewController(withIdentifier: "FilterViewController")
        navigationController?.pushViewController(filterVC, animated: true)
    }
}




extension ChargeStationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let bounds = collectionView.bounds
        var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        switch options.count {
        case 2:
            width = (width - (layout.minimumLineSpacing)) / 2
            return CGSize(width: width, height: 20)
        case 3:
            width = (width - (layout.minimumLineSpacing)) / 3
            return CGSize(width: width, height: 20)
        default:
            break
        }
        
        return .zero
    }
}
