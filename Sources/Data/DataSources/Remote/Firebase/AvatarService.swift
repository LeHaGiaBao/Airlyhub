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

final class AvatarService: AvatarRepositoryProtocol {
    static let shared = AvatarService()

    static let maxEncodedLength = 700_000

    private static let referencePrefix = "rtdb://\(DatabaseNode.avatars)/"

    private init() {}

    var isAvailable: Bool {
        guard let url = FirebaseApp.app()?.options.databaseURL else { return false }
        return !url.isEmpty
    }

    static func reference(uid: String) -> String {
        referencePrefix + uid
    }

    static func uid(fromReference reference: String) -> String? {
        guard reference.hasPrefix(referencePrefix) else { return nil }
        let uid = String(reference.dropFirst(referencePrefix.count))
        return uid.isEmpty ? nil : uid
    }

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

private extension AvatarService {
    func node(for uid: String) -> DatabaseReference? {
        guard isAvailable else { return nil }
        return Database.database().reference(withPath: "\(DatabaseNode.avatars)/\(uid)")
    }
}
