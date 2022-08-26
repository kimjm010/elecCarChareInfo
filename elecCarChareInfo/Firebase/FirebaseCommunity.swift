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
    
    
    // MARK: - Download Comment From Firebase
    
    // TODO: 파이어베이스에 저장했다가 Community VC진입 시 호출하면 호출 -> 호출이 너무 많으면(VC를 계속 왔다갔다 하면) 네트워크 트래픽 증가 -> 캐싱? 아니면 로컬데이터에 저장?
//    func downloadCommentFromFirebase(commentId: String) {
//        FirebaseReference(.comment).document(commentId).getDocument { (querySnapshot, error) in
//
//        }
//    }
}
