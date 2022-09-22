//
//  ChargeStnInfoViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/17/22.
//

import Foundation
import UIKit
import MapKit
import ProgressHUD


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
    @IBOutlet weak var markedImageView: UIImageView!
    
    
    // MARK: - Vars
    
    var chargeStn: ChargeStation?
    var annotation: MKAnnotation?
    var calculatedDistance: Double?
    var userLocation: CLLocationCoordinate2D?
    var isSelected = false
    
    
    // MARK: - IBActions
    
    @IBAction func addMarkButtonTapped(_ sender: Any) {
        isSelected.toggle()
        print(isSelected)
        
        guard let chargeStn = chargeStn,
            let coordinate = chargeStn.coordinate else { return }
        
        FirebaseMarked.shared.registerChargeStation(email: User.currentUser!.email,
                                                    city: chargeStn.city,
                                                    stnPlace: chargeStn.stnPlace,
                                                    stnAddr: chargeStn.stnAddr,
                                                    rapidCnt: chargeStn.rapidCnt,
                                                    slowCnt: chargeStn.slowCnt,
                                                    coordinate: [coordinate[0],
                                                                 coordinate[1]]) { [weak self] error in
            guard let self = self else { return }
            
            if error == nil {
                if self.isSelected {
                    ProgressHUD.showSuccess("충전소가 정상적으로 즐겨찾기에 등록되었습니다.")
                } else {
                    ProgressHUD.showFailed("충전소가 정상적으로 즐겨찾기에서 삭제되었습니다.")
                }
                
            } else {
                ProgressHUD.showFailed("충전소가 정상적으로 등록되지 않았습니다. 잠시 후 다시 시도해주세요:)")
            }
            
            DispatchQueue.main.async {
                self.markedImageView.isHighlighted = self.isSelected
            }
        }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        downloadMarkedChargeStationFromFirebase()
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
    
    
    // MARK: - Download Marked Charge Station From Firebase
    
    private func downloadMarkedChargeStationFromFirebase() {
        FirebaseReference(.marked).getDocuments { [weak self] (queryShapshot, error) in
            guard let self = self else { return }
            guard let document = queryShapshot?.documents else {
                #if DEBUG
                print(error?.localizedDescription)
                #endif
                
                return
            }
            
            let allMakredStations = document.compactMap { (queryDocumentSnapshot) -> ChargeStation? in
                return try? queryDocumentSnapshot.data(as: ChargeStation.self)
            }
            
            guard let chargeStn = self.chargeStn else {
                #if DEBUG
                print(error?.localizedDescription)
                #endif
                
                return
            }
            
            if allMakredStations.contains(where: { User.currentUser?.email == $0.email && $0.stnPlace == chargeStn.stnPlace }) {
                DispatchQueue.main.async {
                    self.markedImageView.isHighlighted = true
                    self.isSelected = true
                }
            }
        }
    }
}
