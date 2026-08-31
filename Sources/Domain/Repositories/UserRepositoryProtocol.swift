//
//  UserRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The `users` profile document, as the feature layer sees it.
protocol UserRepositoryProtocol: AnyObject {
    func fetchUserProfile(uid: String,
                          completion: @escaping (Result<UserModel, Error>) -> Void)

    func createUserProfile(user: UserModel,
                           completion: @escaping (Result<Bool, Error>) -> Void)

    func updateUserProfile(uid: String,
                           data: [String: Any],
                           completion: @escaping (Result<Bool, Error>) -> Void)

    func updateAvatar(uid: String,
                      avatarUrl: String,
                      completion: @escaping (Result<Bool, Error>) -> Void)

    func deleteUserProfile(uid: String,
                           completion: @escaping (Result<Bool, Error>) -> Void)

    func checkUserExists(uid: String, completion: @escaping (Bool) -> Void)
}
