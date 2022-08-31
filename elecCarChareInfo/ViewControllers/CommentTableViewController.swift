//
//  CommunityTableViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import Foundation
import UIKit
import Firebase


class CommentTableViewController: UITableViewController {
    
    // MARK: - Vars
    var comments: [Comment] = []

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "의견 작성", style: .plain, target: self, action: #selector(gotoComposeVC))]
        
        navigationItem.title = "Community"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        downloadCommentFromFirebase()
    }

    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        cell.configure(comment: comment) {
            cell.emailLabel.text = comment.email
            
            if indexPath.row % 2 == 0 {
                cell.commentContainerView.setEvenComment()
            } else {
                cell.commentContainerView.setOddComment()
            }
        }
        return cell
    }
    
    
    // MARK: - Go To Compose Comment VC
    
    @objc
    /// Compose Comment VC로 이동
    private func gotoComposeVC() {
        guard let composeVC = storyboard?.instantiateViewController(withIdentifier: "ComposeCommentViewController") else { return }
        navigationController?.pushViewController(composeVC, animated: true)
    }
    
    
    // MARK: - Download Comment From Firebase
    
    /// Firebase에서 Comment데이터를 가져와서 Local에 있는 Comment 배열에 추가합니다.
    func downloadCommentFromFirebase() {
        FirebaseReference(.comment).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let document = querySnapshot?.documents else { return }
            
            let allComments = document.compactMap { (queryDocumentSnapshot) -> Comment? in
                return try? queryDocumentSnapshot.data(as: Comment.self)
            }
            
            self.comments = allComments
            self.comments.sort { $0.date > $1.date }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
