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
///
/// RTDB is a JSON store, not a file store, so bytes have to travel as base64 — which
/// costs about 33% in size and rules out anything large. Two consequences shape this
/// class:
///
/// 1. **The blob lives outside the message.** A message document in Firestore carries
///    only a `path`; the payload sits at `chatAttachments/{uid}/{attachmentId}` in RTDB.
///    Inlining it would blow Firestore's 1 MiB document cap and force every snapshot of
///    the thread to re-download every image ever sent.
/// 2. **Reads are cached in memory.** RTDB has no CDN and the free plan meters egress,
///    so scrolling past the same photo twice must not fetch it twice.
final class ChatAttachmentService: ChatAttachmentRepositoryProtocol {
    static let shared = ChatAttachmentService()

    private static let rootNode = "chatAttachments"

    /// Decoded payloads keyed by RTDB path. `NSCache` evicts under memory pressure on
    /// its own, which is the right policy for data that can always be re-fetched.
    private let cache = NSCache<NSString, NSData>()

    private init() {
        // ~16 images at the size cap. Enough to scroll a thread without re-fetching,
        // small enough not to matter next to the image decoding downstream.
        cache.totalCostLimit = 8 * 1_024 * 1_024
    }

    /// Whether Realtime Database is configured for this build.
    ///
    /// `Database.database()` raises an Objective-C `MissingDatabaseURL` exception when
    /// `GoogleService-Info.plist` has no `DATABASE_URL` — uncatchable from Swift, so it
    /// takes the whole app down. Reading the option first is the only way to ask the
    /// question safely, and it is why every entry point here goes through this check.
    var isAvailable: Bool {
        guard let url = FirebaseApp.app()?.options.databaseURL else { return false }
        return !url.isEmpty
    }

    /// Path recorded on the message. Derivable from its parts, but stored whole so a
    /// reader never has to know how the tree is laid out.
    static func path(uid: String, attachmentId: String) -> String {
        "\(rootNode)/\(uid)/\(attachmentId)"
    }

    // MARK: UPLOAD Attachment
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
            // Seed the cache from what was just sent: the message appears immediately via
            // the Firestore listener, and without this its own image would round-trip.
            self?.cache.setObject(data as NSData, forKey: path as NSString, cost: data.count)
            completion(.success(path))
        }
    }

    // MARK: READ Attachment
    /// Fetches and decodes an attachment, serving from cache when possible.
    /// Calls back on the main queue — the only caller is a table cell.
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

// MARK: - Private
private extension ChatAttachmentService {
    /// Nil rather than a crash when RTDB isn't configured. Callers have already checked
    /// `isAvailable`; this keeps the guarantee local to where the exception would fire.
    func reference(for path: String) -> DatabaseReference? {
        guard isAvailable else { return nil }
        return Database.database().reference(withPath: path)
    }
}

// MARK: - Errors
enum ChatAttachmentError: LocalizedError {
    case databaseNotConfigured

    var errorDescription: String? {
        switch self {
        case .databaseNotConfigured:
            return NSLocalizedString("chat_error_attachment_unavailable", comment: "")
        }
    }
}
