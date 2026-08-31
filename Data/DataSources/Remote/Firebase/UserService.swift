//
//  UserService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import FirebaseFirestore

final class UserService: UserRepositoryProtocol {
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: GET Full User Profile
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection(FirestoreCollection.users)
            .document(uid)
            .getDocument { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    if let user = try snapshot?.data(as: UserModel.self) {
                        completion(.success(user))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }

    // MARK: CREATE User Profile
    func createUserProfile(user: UserModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try db.collection(FirestoreCollection.users)
                .document(user.uid)
                .setData(from: user) { error in
                    
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(true))
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: UPDATE User Profile
    func updateUserProfile(uid: String, data: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(FirestoreCollection.users)
            .document(uid)
            .updateData(data) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }
    
    // MARK: UPDATE User Avatar
    func updateAvatar(uid: String, avatarUrl: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(FirestoreCollection.users)
            .document(uid)
            .updateData([
                "avatar": avatarUrl
            ]) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }
    
    // MARK: DELETE User Profile
    func deleteUserProfile(uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(FirestoreCollection.users)
            .document(uid)
            .delete { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }
    
    // MARK: READ Check User Exists
    func checkUserExists(uid: String, completion: @escaping (Bool) -> Void) {
        db.collection(FirestoreCollection.users)
            .document(uid)
            .getDocument { snapshot, _ in
                completion(snapshot?.exists ?? false)
            }
    }
}
