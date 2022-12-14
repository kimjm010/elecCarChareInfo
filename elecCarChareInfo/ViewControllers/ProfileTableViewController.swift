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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
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
        
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                alertLogOut(title: "[??????????????????????????????]?????? Log Out ???????????????????", okActionTitle: "Log Out", message: "????????? ????????? ?????? ????????? ?????? ??? ???????????????. ????????? ???????????? ??????????") { [weak self] _ in
                    guard let self = self else { return }
                    do {
                        try Auth.auth().signOut()
                        self.gotoVC("LoginViewController")
                    } catch {
                        print(error.localizedDescription, "???????????? ??? ?????? ??????")
                    }
                }
            } else {
                alertLogOut(title: "[??????????????????????????????]?????? ????????? ?????? ???????????????????", okActionTitle: "Delete Account", message: "????????? ????????? ?????? ????????? ?????? ??? ???????????????. ????????? ????????????????") { [weak self] _ in
                    guard let self = self else { return }
                    guard let user = User.currentUser else { return }
                    FirebaseUser.shared.deleteUserFromFirebase(user)
                    self.gotoVC("LoginViewController")
                    
                }
            }
        case 2:
            gotoVC("AboutThisAppViewController", isPush: true)
        default:
            break
        }
    }
    
    
    // MARK: - Go To Login VC
    
    private func gotoVC(_ vc: String, isPush: Bool = false) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc)
        
        if isPush {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
}
