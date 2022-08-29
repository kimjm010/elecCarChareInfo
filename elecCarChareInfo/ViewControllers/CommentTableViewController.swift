//
//  CommunityTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import UIKit
import Firebase


// TODO: Comment 파이어베이스에서 불러와서 Local에 배열로 저장 -> 변경 사항이 있을 경우 파이어베이스에서 다시 가져와서 저장함 -> 앱을 키거나 Comment VC로 진입할 때
class CommentTableViewController: UITableViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        // TODO: 추가는 되었는데 composeVC로 이동이 안됨
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "의견 작성", style: .plain, target: nil, action: #selector(gotoComposeVC))]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: CommentVC진입 시 Firebase Comment 데이터와 로컬 Comment 데이터 변화있으면 새롭게 fetch할 것
    }

    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: dummyComment 데이터 삭제할 것
        return dummyComment.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        let comment = dummyComment[indexPath.row]
        cell.configure(comment: comment) {
            cell.emailLabel.text = Auth.auth().currentUser?.email
        }
        return cell
    }
    
    
    // MARK: - Table View Delegate
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    // MARK: - Go To Compose Comment VC
    
    @objc
    private func gotoComposeVC() {
        print(#function)
        let composeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComposeCommentViewController")
        composeVC.modalPresentationStyle = .fullScreen
        present(composeVC, animated: true, completion: nil)
    }
}
