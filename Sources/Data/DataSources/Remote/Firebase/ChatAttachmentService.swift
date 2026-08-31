//
//  ChatAttachmentService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

/// Stores support-chat attachments in Realtime Database instead of Cloud Storage,
/// which the free plan doesn't provision.
final class ChatAttachmentService: ChatAttachmentRepositoryProtocol {
    static let shared = ChatAttachmentService()

    private static let rootNode = "chatAttachments"

    private let cache = NSCache<NSString, NSData>()

    private init() {
        cache.totalCostLimit = 8 * 1_024 * 1_024
    }

    var isAvailable: Bool {
        guard let url = FirebaseApp.app()?.options.databaseURL else { return false }
        return !url.isEmpty
    }

    static func path(uid: String, attachmentId: String) -> String {
        "\(rootNode)/\(uid)/\(attachmentId)"
    }

    func upload(uid: String,
                attachmentId: String,
                data: Data,
                completion: @escaping (Result<String, Error>) -> Void) {
        guard isAvailable, let reference = reference(for: Self.path(uid: uid, attachmentId: attachmentId)) else {
            completion(.failure(ChatAttachmentError.databaseNotConfigured))
            return
        }

        let path = Self.path(uid: uid, attachmentId: attachmentId)

        reference.setValue(data.base64EncodedString()) { [weak self] error, _ in
            if let error {
                completion(.failure(error))
                return
            }
            self?.cache.setObject(data as NSData, forKey: path as NSString, cost: data.count)
            completion(.success(path))
        }
    }

    func load(path: String, completion: @escaping (Data?) -> Void) {
        if let cached = cache.object(forKey: path as NSString) {
            completion(cached as Data)
            return
        }

        guard isAvailable, let reference = reference(for: path) else {
            completion(nil)
            return
        }

        reference.getData { [weak self] error, snapshot in
            guard error == nil,
                  let encoded = snapshot?.value as? String,
                  let data = Data(base64Encoded: encoded) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self?.cache.setObject(data as NSData, forKey: path as NSString, cost: data.count)
            DispatchQueue.main.async { completion(data) }
        }
    }
}

private extension ChatAttachmentService {
    func reference(for path: String) -> DatabaseReference? {
        guard isAvailable else { return nil }
        return Database.database().reference(withPath: path)
    }
}

enum ChatAttachmentError: LocalizedError {
    case databaseNotConfigured

    var errorDescription: String? {
        switch self {
        case .databaseNotConfigured:
            return NSLocalizedString("chat_error_attachment_unavailable", comment: "")
        }
    }
}
