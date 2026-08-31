//
//  AvatarRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Storage for the user's profile photo (base64 JPEG in Realtime Database on the
/// free plan, which provisions no Cloud Storage bucket).
///
/// `upload` returns the reference string to save on the Firestore `avatar` field;
/// resolving it back to bytes for display is `UIImageView.setImage(from:)`'s job,
/// not this protocol's.
protocol AvatarRepositoryProtocol: AnyObject {
    /// Whether Realtime Database is configured for this build.
    var isAvailable: Bool { get }

    func uploadAvatar(uid: String,
                      imageData: Data,
                      completion: @escaping (Result<String, Error>) -> Void)

    func fetchAvatar(uid: String,
                     completion: @escaping (Result<Data, Error>) -> Void)

    func deleteAvatar(uid: String,
                      completion: @escaping (Result<Bool, Error>) -> Void)
}
