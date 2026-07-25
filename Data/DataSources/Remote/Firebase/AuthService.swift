//
//  AuthService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    // MARK: Current User
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // MARK: GET Current User UID
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: GET Current User Email
    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    // MARK: GET Current User Name
    func getCurrentUserName() -> String? {
        return Auth.auth().currentUser?.displayName
    }
    
    // MARK: GET Current User Phone
    func getCurrentUserPhone() -> String? {
        return Auth.auth().currentUser?.phoneNumber
    }
    
    // MARK: GET Current User Avatar
    func getCurrentUserAvatar() -> URL? {
        return Auth.auth().currentUser?.photoURL
    }
    
    // MARK: Check Login State
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: Register
    func register(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "SignUpError", code: -1)))
                return
            }
            
            completion(.success(user))
        }
    }
    
    // MARK: Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "SignInError", code: -1)))
                return
            }
            
            completion(.success(user))
        }
    }
    
    // MARK: Logout
    func logout() -> Result<Bool, Error> {
        do {
            try Auth.auth().signOut()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: Reset Password
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: Update Display Name
    func updateDisplayName(name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: Reauthenticate
    func reauthenticate(password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(.failure(NSError(domain: "AuthService", code: -1)))
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { _, error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }

    // MARK: Update Password
    func updatePassword(newPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }

        user.updatePassword(to: newPassword) { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }

    // MARK: Reload User
    func reloadUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(user))
        }
    }
    
    // MARK: Delete Account
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
}
