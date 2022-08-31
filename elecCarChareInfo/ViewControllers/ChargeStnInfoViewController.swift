//
//  ChargeStnInfoViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/17/22.
//

import UIKit
import MapKit


class ChargeStnInfoViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var stnPlaceLabel: UILabel!
    @IBOutlet weak var stnAddrLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slowChargeLabel: UILabel!
    @IBOutlet weak var rapidChargeLabel: UILabel!
    @IBOutlet weak var findDirectionButton: UIButton!
    @IBOutlet weak var addMarkButton: UIButton!
    @IBOutlet weak var slowChargeImageView: UIImageView!
    @IBOutlet weak var rapidChargeImageView: UIImageView!
    
    
    // MARK: - Vars
    
    var chargeStn: ChargeStation?
    var annotation: MKAnnotation?
    var calculatedDistance: Double?
    var userLocation: CLLocationCoordinate2D?
    
    
    // MARK: - IBActions
    
    @IBAction func addMarkButtonTapped(_ sender: Any) {
        // TODO: 유저 즐겨찾기 리스트에 추가할 것
        print(#function)
    }
    
    
    @IBAction func findDirectionButtonTapped(_ sender: Any) {
        guard let annotation = annotation else { return }
        openInMap(to: annotation)
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeData()
    }
    
    
    /// 데이터를 초기화 합니다.
    private func initializeData() {
        stnPlaceLabel.text = chargeStn?.stnPlace
        stnAddrLabel.text = chargeStn?.stnAddr
        distanceLabel.text = "\(calculatedDistance ?? 0)km"
        findDirectionButton.setEnableBtnTheme()
        addMarkButton.setTitle("", for: .normal)
        
        slowChargeImageView.alpha = chargeStn?.slowCnt == 0 ? 0.3 : 1.0
        slowChargeLabel.alpha = slowChargeImageView.alpha
        rapidChargeImageView.alpha = chargeStn?.rapidCnt == 0 ? 0.3 : 1.0
        rapidChargeLabel.alpha = rapidChargeImageView.alpha
        
        slowChargeLabel.text = "완속: \(chargeStn?.slowCnt ?? 0)"
        rapidChargeLabel.text = "급속: \(chargeStn?.rapidCnt ?? 0 )"
    }
    
    
    // MARK: - Open In Map
    
    /// 애플 지도 연동하여 해당 위치까지 경로 제공
    /// - Parameter annotation: 목적지의 annotation 객체
    private func openInMap(to annotation: MKAnnotation) {
        guard let userLocation = userLocation else { return }

        let source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        source.name = "Current Location"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        destination.name = annotation.title ?? "Unknown"
        print(destination)
        
        MKMapItem.openMaps(with: [source, destination],
                           launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
