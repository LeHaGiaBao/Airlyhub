//
//  AuthenticatedUser.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The account as the feature layer sees it — the identity fields the app reads
/// off the auth session, with none of `FirebaseAuth.User` behind them.
///
/// `AuthRepositoryProtocol` hands this back instead of the SDK type so an
/// interactor never has to `import FirebaseAuth` to learn who is signed in.
struct AuthenticatedUser: Equatable {
    let uid: String
    let email: String?
    let displayName: String?
    let phoneNumber: String?
    let photoURL: URL?
}
