//
//  ProfileTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import UIKit
import Firebase


class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 2
        }
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User"
        case 1:
            return "Manage User"
        case 2:
            return "Information About This App"
        default:
            break
        }
        
        return nil
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Auth.auth().currentUser?.email
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Log Out"
            }
            
            cell.textLabel?.text = "Deleter Account"
        case 2:
            cell.textLabel?.text = "About This App"
        default:
            break
        }

        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: 계정 로그아웃 하기 -> 로그아웃만 실행
        //"전기차 충전소 관련 정보를 얻을 수 없는데, [~~앱]에서 로그아웃 하겠습니까?"
        //"Log Out 하시겠습니까?"
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                alertLogOut(title: "[~~앱]에서 Log Out 하시겠습니까?", message: "전기차 충전소 관련 정보를 얻을 수 없게됩니다. 그래도 로그아웃 할까요?") { _ in
                    // TODO: 계정 로그아웃 하기 -> 로그아웃만 실행
                }
            }
            
            alertLogOut(title: "[~~앱]에서 계정을 삭제 하시겠습니까?", message: "전기차 충전소 관련 정보를 얻을 수 없게됩니다. 그래도 삭제할까요?") { _ in
                // TODO: 계정 삭제하기 -> User Defaults, Firebase에서 계정 삭제할 것
            }
            
        case 2:
            let appVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutThisAppViewController")
            present(appVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
}
