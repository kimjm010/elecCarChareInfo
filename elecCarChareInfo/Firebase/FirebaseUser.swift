//
//  FirebaseUser.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/23/22.
//

import Foundation
import Firebase


class FirebaseUser {
    static let shared = FirebaseUser()
    private init() { }
    
    
    // MARK: - Login
    
    /// 생성한 User객체를 통해 로그인 합니다.
    /// - Parameters:
    ///   - email: User 객체의 email
    ///   - password: User 객체의 password
    ///   - completion: 로그인 후의 작업
    func loginUserWith(email: String,
                       password: String,
                       completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil && authDataResult!.user.isEmailVerified {
                
                FirebaseUser.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                
                completion(error, true)
            } else {
                #if DEBUG
                print("이메일 인증 절차가 확인되지 않았습니다.")
                completion(error, false)
                #endif
            }
        }
    }
    
    
    // MARK: - Register
    
    /// 새로운 User객체를 등록합니다.
    /// - Parameters:
    ///   - email: 새로운 User 객체의 email
    ///   - password: 새로운 User 객체의 password
    ///   - completion: 새로운 User 객체 등록 후 진행할 작업
    func registerUserWith(email: String,
                          password: String,
                          completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authDataResult, errror) in
            guard let self = self else { return }
            completion(errror)
            
            if errror == nil {
                // verification email 전송
                authDataResult!.user.sendEmailVerification { (error) in
                    #if DEBUG
                    print("확인 이메일 전송 에러: ", errror?.localizedDescription)
                    #endif
                }
                
                // User 객체 생성
                if authDataResult != nil {
                    let user = User(id: authDataResult!.user.uid, email: email)
                    
                    saveUserLocally(user)
                    self.saveUserToFireStore(user)
                }
            }
        }
    }
    
    
    // MARK: - Resend Verification Email
    
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    completion(error)
            })
        })
    }
    
    
    // MARK: -  Reset Password
    
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    
    // MARK: - Save User To FireStore
    
    /// User 객체를JSON으로 변환 후 FireStore에 저장합니다.
    /// - Parameter user: 저장할 user객체
    func saveUserToFireStore(_ user: User) {
        do {
            try FirebaseReference(.user).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription, "파이어 스토어에 유저 저장시 에러 발생!!")
        }
    }
    
    
    // MARK: - Delete User From FireStore
    
    func deleteUserFromFireStore(_ user: User) {
        
        let path = FirebaseReference(.user)
        
        path.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            }
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                guard var data = document["\(user.id)"] as? [String: String] else { return }
                data["email"] = nil
                data["id"] = nil
                
                path.document(user.id).updateData(["\(user.id)" : data])
            }
        }
        
        print(#function, "계정이 삭제되었습니다.", "파이어베이스에서 확인 할 것", "UserDefaults에서도 삭제 되었어요!", "(())&&^)", User.currentUser?.email)
    }
    
    
    // MARK: - Download User From Firebase
    
    /// Firebase에서 User데이터를 가져와서 Local에 있는 User 데이터를 업데이트 한다
    /// - Parameters:
    ///   - userId: User객체의 userId
    ///   - email: User객체의 email
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        FirebaseReference(.user).document(userId).getDocument { (querySnapshot, error) in
            guard let document = querySnapshot else {
                #if DEBUG
                print("document가 존재하지 않습니다.")
                #endif
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document가 존재하지 않습니다.")
                }
            case .failure(let error):
                #if DEBUG
                print("User 디코딩 중 에러 발생", error.localizedDescription)
                #endif
            }
        }
    }
}
