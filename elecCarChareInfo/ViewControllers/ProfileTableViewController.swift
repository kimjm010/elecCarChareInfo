//
//  ProfileTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import UIKit
import Firebase
import FirebaseAuth


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
            } else {
                cell.textLabel?.text = "Delete Account"
            }
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
        
        print(indexPath.section, indexPath.row)
        
        // TODO: 계정 로그아웃 하기 -> 로그아웃만 실행
        //"전기차 충전소 관련 정보를 얻을 수 없는데, [~~앱]에서 로그아웃 하겠습니까?"
        //"Log Out 하시겠습니까?"
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                
                alertLogOut(title: "[전기차충전소어디있어]에서 Log Out 하시겠습니까?", okActionTitle: "Log Out", message: "전기차 충전소 관련 정보를 얻을 수 없게됩니다. 그래도 로그아웃 할까요?") { [weak self] _ in
                    guard let self = self else { return }
                    do {
                        try Auth.auth().signOut()
                        self.gotoVC("LoginViewController")
                    } catch {
                        print(error.localizedDescription, "로그아웃 중 에러 발생")
                    }
                }
            } else {
                alertLogOut(title: "[전기차충전소어디있어]에서 계정을 삭제 하시겠습니까?", okActionTitle: "Delete Account", message: "전기차 충전소 관련 정보를 얻을 수 없게됩니다. 그래도 삭제할까요?") { [weak self] _ in
                    guard let self = self else { return }
                    guard let user = User.currentUser else { return }
                    FirebaseUser.shared.deleteUserFromFireStore(user)
                    self.gotoVC("LoginViewController")
                    
                }
            }
        case 2:
            gotoVC("AboutThisAppViewController")
//            let appVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutThisAppViewController")
//            present(appVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    // MARK: - Go To Login VC
    
    private func gotoVC(_ vc: String) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc)
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
