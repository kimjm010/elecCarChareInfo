//
//  FirebaseCommunity.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/26/22.
//

import Foundation
import Firebase


class FirebaseCommunity {
    static let shared = FirebaseCommunity()
    private init() { }
    
    // MARK: - Vars
    var comments: [Comment] = []
    
    
    // MARK: - Save Comment To FireStore
    
    /// Comment객체를 JSON으로 변환 후 FireStore에 저장합니다.
    /// - Parameter comment: 저장할 Comment 객체
    func saveCommentToFireStore(_ comment: Comment) {
        do {
            try FirebaseReference(.comment).document(comment.id).setData(from: comment)
        } catch {
            #if DEBUG
            print(error.localizedDescription, "파이어 스토어에 Comment 저장 시 에러 발생!!")
            #endif
        }
    }
    
    
    // MARK: - Register Comment
    
    func registerComment(email: String,
                         content: String,
                         date: String,
                         completion: @escaping (_ error: Error?) -> Void) {
        guard let user = User.currentUser else {
            return
        }
        
        let comment = Comment(id: user.id, email: email, comment: content, date: date)
        saveCommentToFireStore(comment)
    }
    
    
    // MARK: - Download Comment From Firebase
    
    // TODO: 파이어베이스에 저장했다가 Community VC진입 시 호출하면 호출 -> 호출이 너무 많으면(VC를 계속 왔다갔다 하면) 네트워크 트래픽 증가 -> 캐싱? 아니면 로컬데이터에 저장?
    
    /// Firebase에서 Comment데이터를 가져와서 Local에 있는 Comment 배열에 추가합니다.
    /// - Parameter commentId: 저장할 commentID
    func downloadCommentFromFirebase(commentId: String) {
        FirebaseReference(.comment).document(commentId).getDocument { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let document = querySnapshot else {
                #if DEBUG
                print("document가 존재하지 않습니다. -> 파일이 없어요!")
                #endif
                return
            }
            
            let result = Result {
                try? document.data(as: Comment.self)
            }
            
            switch result {
            case .success(let commentObject):
                if let comment = commentObject {
                    self.comments.append(comment)
                }
            case .failure(let error):
                #if DEBUG
                print("Comment 디코딩 중 에러 발생", error.localizedDescription)
                #endif
            }
        }
    }
}
