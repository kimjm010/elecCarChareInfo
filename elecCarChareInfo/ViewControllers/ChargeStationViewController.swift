//
//  ChargeStationViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/11/22.
//

import UIKit
import CoreLocation
import MapKit


struct TempChargeStn {
    let id: Int
    let metro: String
    let city: String
    let stnPlace: String
    let stnAddr: String
    let rapidCnt: Int
    let slowCnt: Int
    let carType: String
    let coordinate: CLLocationCoordinate2D
    var annotation: MKAnnotation {
        return ChargeStnAnnotation(coordinate: coordinate,
                                   stnId: id,
                                   title: stnPlace,
                                   subtitle: stnAddr)
    }
}


class ChargeStationViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var optionContainerStackView: UIStackView!
    
    
    // MARK: Vars
    
    /*
     var list = [ChargeStn]() {
     willSet {
     mapView.removeAnnotations(allAnnotations)
     allAnnotations.removeAll()
     }
     didSet {
     let newAnnotations = list.map { $0.annotation }
     allAnnotations = newAnnotations
     mapView.addAnnotations(allAnnotations)
     registerMapAnnotationViews()
     }
     }
     */
    
    
    /// CLLocationManager 관리 객체
    lazy var locationManager: CLLocationManager = { [weak self] in
        let m = CLLocationManager()
        
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        
        return m
    }()
    
    // options 배열
    var options = [Option(optionName: "Filter", optionImage: UIImage(systemName: "slider.horizontal.3"))]
    
    /*
     // 임시 충전소 주소 배열
     // TODO: DB 적용해서 DB에서 가져와서 작업 해보자
     lazy var tempChargeStnLocation: [CLLocationCoordinate2D] = {
     var tempArray: [CLLocationCoordinate2D] = []
     for i in 0 ..< dummyChargeStation.count {
     getCoordinate(dummyChargeStation[i].stnAddr) { (location, error) in
     tempArray.append(location)
     print(location.latitude, location.longitude, i, "&&")
     }
     }
     
     return tempArray
     }()
     */
    
    
    // MARK: IBActions
    @IBAction func goToCurrentLocation(_ sender: Any) {
        print(#function)
        // TODO: 현재위치(디바이스 위치)로 위치로 돌아갈 것
    }
    
    
    @IBAction func registerMarked(_ sender: Any) {
        print(#function)
        // TODO: 내 정보에 즐겨찾기 추가할 것
    }
    
    
    @IBAction func chageMode(_ sender: Any) {
        print(#function)
        // TODO: 앱의 화면 모드 변경할 것 / 기본값은 디바이스 설정 값
    }
    
    
    @IBAction func zoomInPressed(_ sender: Any) {
        print(#function)
        // TODO: 확대 할 것
    }
    
    
    @IBAction func zoomOutPressed(_ sender: Any) {
        print(#function)
        // TODO: 축소 할 것
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuth()
        
        mapView.delegate = self
        //        mapView.addAnnotations(dummyMakrs)
        registerMapAnnotationViews()
        
        let initCntrCoordinate = dummyChargeStationData.first?.coordinate ?? CLLocationCoordinate2D(latitude: 37.4718415, longitude: 127.0877141)
        let region = MKCoordinateRegion(center: initCntrCoordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    
    /// Check User's Location Authorization
    private func checkLocationAuth() {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            
            status = locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // TODO: 경고창 + 설정으로 이동
                break
            case  .denied:
                // TODO: 경고창 + 설정으로 이동
                break
            case .authorizedAlways, .authorizedWhenInUse:
                updateLocation()
                break
            default:
                break
            }
        }
    }
    
    
    // MARK: - Annotation Views
    
    /// 지도에서 사용할 annotation View 타입을 등록합니다.
    private func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ChargeStnAnnotation.self))
        
        let annotations: [ChargeStnAnnotation] = dummyChargeStationData.map { (charge) in
            return ChargeStnAnnotation(coordinate: charge.coordinate,
                                       stnId: charge.id,
                                       title: charge.stnPlace,
                                       subtitle: charge.stnAddr)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    
    /// 해당 좌표에 원을 표시
    /// - Parameter coordinate: CLLocationCoordinate2D객체
    private func addCircle(at coordinate: CLLocationCoordinate2D) {
        
        // overlay생성 후 mapView에 추가
        let circle = MKCircle(center: coordinate, radius: 100)
        mapView.addOverlay(circle)
    }
    
    
    private func addPolygon(at coordinate: CLLocationCoordinate2D) {
        let coordinates = Array(dummyChargeStationData.map { $0.coordinate } [0...2])
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon)
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




// MARK: - CLLocationManager Delegate

extension ChargeStationViewController: CLLocationManagerDelegate {
    
    func updateLocation() {
        locationManager.startUpdatingHeading()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            updateLocation()
            break
        case .restricted, .denied:
            // TODO: 경고창 + 설정으로 이동
            break
        default:
            // TODO: 경고창 + 설정으로 이동
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingHeading()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Forward Geo Coding으로 주소 -> 경위도로 변환할 것
        print(#function)
    }
}




// MARK:  - MKMapViewDelegate

extension ChargeStationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: 밑에 뷰로 충전소 정보 화면 띄우고 쓸어올리면 modal 방식으로 전체화면 표시
        // TODO: OpenInMap으로 이동
        print(#function)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? MKClusterAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            view.markerTintColor = .systemBlue
        }
        
        if let annoation = annotation as? MKPointAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            
            view.markerTintColor = .brown
            view.glyphImage = UIImage(named: "chargeStn")
            
            return view
        }
        
        let annotationImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "chargeStn")
        annotationView?.image = image
        
        let annotationLabel = UILabel(frame: CGRect(x: 0, y: -35, width: 45, height: 45))
        annotationLabel.backgroundColor = .systemOrange
        annotationLabel.textColor = .white
        annotationLabel.numberOfLines = 3
        annotationLabel.textAlignment = .center
        annotationLabel.font = UIFont.boldSystemFont(ofSize: 10)
        annotationLabel.text = annotation.title!
        
        annotationView?.addSubview(annotationImgView)
        annotationView?.addSubview(annotationLabel)
        
        
        
        return annotationView
        
        /*
         if let annotation = annotation as? MKClusterAnnotation {
         let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
         view.markerTintColor = UIColor.systemBlue
         
         return view
         }
         
         if let annotation = annotation as? ChargeStnAnnotation {
         let view = mapView.dequeueReusableAnnotationView(withIdentifier: "charge", for: annotation) as! MKMarkerAnnotationView
         view.canShowCallout = false
         
         let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         imageView.image = UIImage(named: "chargeStn")
         
         view.detailCalloutAccessoryView = imageView
         
         return view
         }
         */
        
        
        /*
         guard !(annotation.isKind(of: MKUserLocation.self)) else { return nil }
         
         var annotationView: MKAnnotationView?
         
         if let annotation = annotation as? MKClusterAnnotation {
         let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
         clusterView.markerTintColor = UIColor.systemGray6
         return clusterView
         }
         
         let tempImage = UIImage(systemName: "chargeStn")
         
         if let annotation = annotation as? ChargeStnAnnotation {
         let tintColor = UIColor.systemRed
         let glyphImage = tempImage
         annotationView = setupChargeStnAnnotationView(for: annotation, on: mapView, tintColor: tintColor, image: glyphImage)
         }
         
         return annotationView
         */
        
    }
    
    /*
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
     if let overlay = overlay as? MKCircle {
     let render = MKCircleRenderer(overlay: overlay)
     render.strokeColor = UIColor.systemRed
     
     return render
     } else if let overlay = overlay as? MKPolygon {
     let render = MKPolygonRenderer(overlay: overlay)
     render.strokeColor = UIColor.systemBlue
     
     return render
     } else if let overlay = overlay as? MKMultiPolyline {
     let render = MKMultiPolygonRenderer(overlay: overlay)
     render.lineWidth = 5
     render.strokeColor = UIColor.systemRed
     
     return render
     }
     
     return MKOverlayRenderer(overlay: overlay)
     }
     */
    
    
    
    /// 지도에 표시할 annotation View를 제공합니다.
    ///
    /// 제네릭 메소드이므로, 특정 annotation의 타입으로 전달되고 view는 재사용 됩니다.
    ///
    /// - Parameters:
    ///   - annotation: annotation
    ///   - mapView: annotation 표시할 mapView
    ///   - tintColor: marker의 tint Color
    ///   - image: marker의 glyph Image
    /// - Returns: annotationView
    private func setupChargeStnAnnotationView<AnnotationType: ChargeStnAnnotation>(for annotation: AnnotationType, on mapView: MKMapView, tintColor: UIColor, image: UIImage? = nil) -> MKAnnotationView {
        let identifier = NSStringFromClass(ChargeStnAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = tintColor
            markerAnnotationView.glyphImage = image
            
            // callout 표시
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
    
    
    /// callout이 tap되었을 때 충전소 정보를 화면에 표시합니다.
    ///
    /// - Parameters:
    ///   - mapView: annotation View가 표시된 mapView
    ///   - view: callout의 annotation View
    ///   - control: tap 이벤트가 발생한 컨트롤
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChargeStnInfoTableViewController") as! ChargeStnInfoTableViewController
        
        navigationController?.pushViewController(vc, animated: true)
        optionContainerStackView.isHidden = true
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




// MARK: - UICollectionView Delegate

extension ChargeStationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterTableViewController") as! FilterTableViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
