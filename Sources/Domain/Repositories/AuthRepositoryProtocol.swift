//
//  AuthRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The auth session, as the feature layer sees it.
protocol AuthRepositoryProtocol: AnyObject {
    var currentUser: AuthenticatedUser? { get }

    func getCurrentUserId() -> String?
    func getCurrentUserEmail() -> String?
    func getCurrentUserName() -> String?
    func getCurrentUserPhone() -> String?
    func getCurrentUserAvatar() -> URL?

    func isLoggedIn() -> Bool

    func register(email: String,
                  password: String,
                  completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    func login(email: String,
               password: String,
               completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    func logout() -> Result<Bool, Error>

    func resetPassword(email: String,
                       completion: @escaping (Result<Bool, Error>) -> Void)

    func updateDisplayName(name: String,
                           completion: @escaping (Result<Bool, Error>) -> Void)

    func reauthenticate(password: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)

    func updatePassword(newPassword: String,
                        completion: @escaping (Result<Bool, Error>) -> Void)

    func reloadUser(completion: @escaping (Result<AuthenticatedUser, Error>) -> Void)

    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void)
}
