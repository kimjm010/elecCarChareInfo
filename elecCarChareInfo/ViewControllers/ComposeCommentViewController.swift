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
        createNavItems(title: "Done")
        commentTextField.delegate = self
        commentTextField.placeholder = "한 줄평을 작성해주세요:) (50자 이내)"
    }
    
    
    // MARK: - Create Navibation Items
    
    /// Navigation Item 생성
    /// - Parameter rightTitle: Nav Item의 title
    private func createNavItems(title: String) {
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(createCommentObject))
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    // MARK: - Create Comment Object
    
    @objc
    /// Comment 객체 생성
    private func createCommentObject() {
        guard let email = User.currentUser?.email,
              let text = commentTextField.text else { return }
        createComment(userEmail: email, content: text, date: Date().commentDate)
    }
    
    
    /// 생성한 Comment객체를 Firebase에 저장합니다.
    /// - Parameters:
    ///   - userEmail: user Email
    ///   - content: 한줄 평 의견
    ///   - date: 입력 date
    private func createComment(userEmail: String, content: String, date: String) {
        guard !(content.isEmpty) else {
            ProgressHUD.showFailed("Comment등록을 위해 한 줄평을 작성해주세요!")
            return
        }
        
        FirebaseCommunity.shared.registerComment(email: userEmail, content: content, date: date) { error in
            if error == nil {
                ProgressHUD.showSuccess("의견이 정상적으로 등록되었습니다.")
            } else {
                ProgressHUD.showFailed("의견이 정상적으로 등록되지 않았습니다. 잠시 후 다시 시도해주세요:)")
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}




extension ComposeCommentViewController: UITextFieldDelegate {
    
    /// 글자수를 50자 이하로 제한합니다.
    /// - Parameter textField: commentTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let txtCnt = commentTextField.text?.count else { return }
        
        if txtCnt > 50 {
            ProgressHUD.showFailed("50자 이상입니다.")
        }
    }
}
