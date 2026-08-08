//
//  AvatarService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 09/08/2026.
//

import Foundation
import FirebaseDatabase

enum AvatarServiceError: Error {
    case imageTooLarge
    case notFound
    case invalidData
}

/// Stores avatars as base64 JPEG strings in Realtime Database instead of Storage,
/// which is unavailable on the Spark (free) plan.
final class AvatarService {
    static let shared = AvatarService()

    /// Matches the `avatars/$uid` security rule, which rejects longer strings server-side.
    static let maxEncodedLength = 700_000

    private static let referencePrefix = "rtdb://\(DatabaseNode.avatars)/"

    private let database = Database.database().reference()

    private init() {}

    /// Value written to the user's Firestore `avatar` field. Not a real URL — the
    /// bytes live in Realtime Database and are resolved by
    /// `UIImageView.setImage(from:placeholder:)`.
    static func reference(uid: String) -> String {
        referencePrefix + uid
    }

    /// Inverse of `reference(uid:)`. Returns `nil` for plain URLs so legacy
    /// Storage-hosted avatars keep loading over HTTP.
    static func uid(fromReference reference: String) -> String? {
        guard reference.hasPrefix(referencePrefix) else { return nil }
        let uid = String(reference.dropFirst(referencePrefix.count))
        return uid.isEmpty ? nil : uid
    }

    // MARK: UPLOAD User Avatar
    func uploadAvatar(uid: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let encoded = imageData.base64EncodedString()
        guard encoded.count <= Self.maxEncodedLength else {
            completion(.failure(AvatarServiceError.imageTooLarge))
            return
        }

        database.child(DatabaseNode.avatars)
            .child(uid)
            .setValue(encoded) { error, _ in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Self.reference(uid: uid)))
            }
    }

    // MARK: GET User Avatar
    func fetchAvatar(uid: String, completion: @escaping (Result<Data, Error>) -> Void) {
        database.child(DatabaseNode.avatars)
            .child(uid)
            .getData { error, snapshot in
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let encoded = snapshot?.value as? String else {
                    completion(.failure(AvatarServiceError.notFound))
                    return
                }

                guard let data = Data(base64Encoded: encoded) else {
                    completion(.failure(AvatarServiceError.invalidData))
                    return
                }

                completion(.success(data))
            }
    }

    // MARK: DELETE User Avatar
    func deleteAvatar(uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        database.child(DatabaseNode.avatars)
            .child(uid)
            .removeValue { error, _ in
                if let error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
    }
}
