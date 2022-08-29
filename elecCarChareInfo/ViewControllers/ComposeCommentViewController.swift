//
//  ComposeCommentViewController.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/26/22.
//

import UIKit
import ProgressHUD

// TODO: Comment 등록 후 ViewController 닫기 + textField 비우기


class ComposeCommentViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Compose Comment"
        createNavItems(rightTitle: "Done")
        commentTextField.delegate = self
        commentTextField.placeholder = "한 줄평을 작성해주세요:) (50자 이내)"
    }
    
    
    // MARK: - Create Navibation Items
    
    private func createNavItems(rightTitle: String) {
        let rightButton = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: #selector(createCommentObject))
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    // MARK: - Create Comment Object
    
    @objc
    private func createCommentObject() {
        guard let email = User.currentUser?.email,
        let text = commentTextField.text else { return }
        createComment(userEmail: email, content: text, date: Date().commentDate)
    }
    
    
    private func createComment(userEmail: String, content: String, date: String) {
        guard !(content.isEmpty) else {
            ProgressHUD.showFailed("Comment등록을 위해 한 줄평을 작성해주세요!")
            return
        }
        
        FirebaseCommunity.shared.registerComment(email: userEmail, content: content, date: date) { error in
            if error == nil {
                ProgressHUD.showSuccess("의견이 정상적으로 등록되었습니다.")
                self.navigationController?.popViewController(animated: true)
            } else {
                ProgressHUD.showFailed("의견이 정상적으로 등록되지 않았습니다. 잠시 후 다시 시도해주세요:)")
                print(error?.localizedDescription)
            }
        }
        
        print(#function, "파이어 베이스에 커멘트가 저장되었습니다")
    }
}




extension ComposeCommentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let txtCnt = commentTextField.text?.count else { return }
        
        if txtCnt > 50 {
            ProgressHUD.showFailed("50자 이상입니다.")
        }
    }
}
