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
    
    // MARK: - Save Comment
    
    /// Comment객체를 JSON으로 변환 후 FireStore에 저장합니다.
    /// - Parameter comment: 저장할 Comment 객체
    func saveCommentToFirebase(_ comment: Comment) {
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
        guard let user = User.currentUser else { return }
        
        let comment = Comment(id: UUID().uuidString,
                              email: user.email,
                              comment: content,
                              date: Date().commentDate)
        completion(nil)
        saveCommentToFirebase(comment)
    }
}
