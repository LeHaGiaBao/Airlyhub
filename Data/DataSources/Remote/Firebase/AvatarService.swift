//
//  AvatarService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 09/08/2026.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

/// Not `LocalizedError`: `EditProfilePresenter` shows its own toast for any avatar
/// failure, so an `errorDescription` here would never reach the screen.
enum AvatarServiceError: Error {
    case databaseNotConfigured
    case imageTooLarge
    case notFound
    case invalidData
}

/// Stores avatars as base64 JPEG strings in Realtime Database instead of Cloud Storage,
/// which the free plan doesn't provision. Same shape as `ChatAttachmentService`, minus
/// the cache — a profile photo is fetched once per screen, not once per scrolled row.
final class AvatarService {
    static let shared = AvatarService()

    /// Matches the `avatars/$uid` security rule, which rejects longer strings server-side.
    static let maxEncodedLength = 700_000

    private static let referencePrefix = "rtdb://\(DatabaseNode.avatars)/"

    private init() {}

    /// Whether Realtime Database is configured for this build.
    ///
    /// `Database.database()` raises an Objective-C `MissingDatabaseURL` exception when
    /// `GoogleService-Info.plist` has no `DATABASE_URL` — uncatchable from Swift, so it
    /// takes the whole app down. Reading the option first is the only way to ask the
    /// question safely, and it is why the reference is resolved per call rather than
    /// held as a stored property, which would fire at `shared` init.
    var isAvailable: Bool {
        guard let url = FirebaseApp.app()?.options.databaseURL else { return false }
        return !url.isEmpty
    }

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
        guard let node = node(for: uid) else {
            completion(.failure(AvatarServiceError.databaseNotConfigured))
            return
        }

        let encoded = imageData.base64EncodedString()
        guard encoded.count <= Self.maxEncodedLength else {
            completion(.failure(AvatarServiceError.imageTooLarge))
            return
        }

        node.setValue(encoded) { error, _ in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(Self.reference(uid: uid)))
        }
    }

    // MARK: GET User Avatar
    func fetchAvatar(uid: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let node = node(for: uid) else {
            completion(.failure(AvatarServiceError.databaseNotConfigured))
            return
        }

        node.getData { error, snapshot in
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
        guard let node = node(for: uid) else {
            completion(.failure(AvatarServiceError.databaseNotConfigured))
            return
        }

        node.removeValue { error, _ in
            if let error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
}

// MARK: - Private
private extension AvatarService {
    /// Nil rather than a crash when RTDB isn't configured.
    func node(for uid: String) -> DatabaseReference? {
        guard isAvailable else { return nil }
        return Database.database().reference(withPath: "\(DatabaseNode.avatars)/\(uid)")
    }
}
