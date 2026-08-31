//
//  AuthRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The auth session, as the feature layer sees it.
///
/// Same intent as `TourRepositoryProtocol`: the concrete store (`AuthService`
/// over `FirebaseAuth` today, a fake in tests tomorrow) is chosen once at the
/// composition root, and no interactor imports the SDK to sign a user in or read
/// the current uid.
///
/// Completions fire on `FirebaseAuth`'s callback queue — the same as the concrete
/// `AuthService` does now — so callers that touch UI still hop to the main queue
/// themselves.
protocol AuthRepositoryProtocol: AnyObject {
    /// The signed-in account, or `nil` when logged out.
    var currentUser: AuthenticatedUser? { get }

    func getCurrentUserId() -> String?
    func getCurrentUserEmail() -> String?
    func getCurrentUserName() -> String?
    func getCurrentUserPhone() -> String?
    func getCurrentUserAvatar() -> URL?

    /// `true` while a session exists — the check `SceneDelegate` / `AppRouter`
    /// use to pick the first screen.
    func isLoggedIn() -> Bool

    func register(email: String,
                  password: String,
                  completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    func login(email: String,
               password: String,
               completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    /// Synchronous — `Auth.signOut()` only throws on a keychain failure.
    func logout() -> Result<Bool, Error>

    func resetPassword(email: String,
                       completion: @escaping (Result<Bool, Error>) -> Void)

    func updateDisplayName(name: String,
                           completion: @escaping (Result<Bool, Error>) -> Void)

    /// Re-checks the password against the live session; required by Firebase
    /// before `updatePassword` / `deleteAccount` on an old session.
    func reauthenticate(password: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)

    func updatePassword(newPassword: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)

    func reloadUser(completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void)
}
