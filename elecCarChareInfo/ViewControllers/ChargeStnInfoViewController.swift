//
//  ChargeStnInfoViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/17/22.
//

import UIKit
import MapKit


class ChargeStnInfoViewController: UIViewController {
    
    // MARK: - Vars
    var chargeStn: ChargeStation?
    var annotation: MKAnnotation?
    var calculatedDistance = 1.5 // TODO: 직접 계산된 거리로 변경할 것
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var stnPlaceLabel: UILabel!
    @IBOutlet weak var stnAddrLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slowChargeLabel: UILabel!
    @IBOutlet weak var rapidChargeLabel: UILabel!
    @IBOutlet weak var findDirectionButton: UIButton!
    
    

    // MARK: - IBActions
    
    @IBAction func addMarkButtonTapped(_ sender: Any) {
        // TODO: 유저 즐겨찾기 리스트에 추가할 것
        print(#function)
    }
    
    
    @IBAction func findDirectionButtonTapped(_ sender: Any) {
        // TODO: ios 지도앱으로 바로 연결
//
//        let directionVC = storyboard?.instantiateViewController(withIdentifier: "ShowRouteViewController") as? ShowRouteViewController
//        directionVC?.chargeStn = chargeStn
//        directionVC?.annotation = annotation
//
//        directionVC?.modalPresentationStyle = .automatic
//        directionVC?.modalTransitionStyle = .crossDissolve
//        directionVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: #selector(closeVC))
//        present(directionVC!, animated: true, completion: nil)
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
        distanceLabel.text = "\(calculatedDistance)km"
        slowChargeLabel.text = "완속: \(chargeStn?.slowCnt ?? 0)"
        rapidChargeLabel.text = "급속: \(chargeStn?.rapidCnt ?? 0 )"
        findDirectionButton.setEnableBtnTheme()
    }
}
