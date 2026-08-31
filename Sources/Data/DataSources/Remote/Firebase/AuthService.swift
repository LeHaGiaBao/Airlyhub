//
//  AuthService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation
import FirebaseAuth

final class AuthService: AuthRepositoryProtocol {
    static let shared = AuthService()

    private init() {}

    var currentUser: AuthenticatedUser? {
        Auth.auth().currentUser.map(AuthenticatedUser.init)
    }

    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }

    func getCurrentUserName() -> String? {
        return Auth.auth().currentUser?.displayName
    }

    func getCurrentUserPhone() -> String? {
        return Auth.auth().currentUser?.phoneNumber
    }

    func getCurrentUserAvatar() -> URL? {
        return Auth.auth().currentUser?.photoURL
    }

    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func register(email: String, password: String, completion: @escaping (Result<AuthenticatedUser, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(domain: "SignUpError", code: -1)))
                return
            }

            completion(.success(AuthenticatedUser(user)))
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<AuthenticatedUser, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(domain: "SignInError", code: -1)))
                return
            }

            completion(.success(AuthenticatedUser(user)))
        }
    }

    func logout() -> Result<Bool, Error> {
        do {
            try Auth.auth().signOut()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }

    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }

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

    func reloadUser(completion: @escaping (Result<AuthenticatedUser, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }

        user.reload { error in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(AuthenticatedUser(user)))
        }
    }

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

private extension AuthenticatedUser {
    init(_ user: User) {
        self.init(uid: user.uid,
                  email: user.email,
                  displayName: user.displayName,
                  phoneNumber: user.phoneNumber,
                  photoURL: user.photoURL)
    }
}
