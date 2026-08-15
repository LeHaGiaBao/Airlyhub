//
//  ChatMessageModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Who wrote a message. Stored as a string in Firestore and cross-checked by the
/// security rules against the caller's auth token, so a client can never claim to
/// be `agent` — see firestore.rules.
enum MessageSenderRole: String, Codable {
    /// The signed-in customer.
    case user
    /// A human support operator.
    case agent
    /// An automated reply.
    case bot

    /// Everything that isn't the customer renders on the left-hand side.
    var isSupport: Bool { self != .user }
}

/// A file sent alongside a message. Only the metadata lives in Firestore — the bytes
/// are base64 in Realtime Database under `chatAttachments/{uid}/...`, because the free
/// plan provisions no Cloud Storage bucket.
struct ChatAttachment: Equatable {
    /// RTDB node holding the payload.
    let path: String
    let name: String
    let contentType: String
    /// Original byte count, before base64.
    let size: Int

    var isImage: Bool { contentType.hasPrefix("image/") }
}

/// One message in the support thread.
struct ChatMessageModel: Equatable {
    let id: String
    let senderRole: MessageSenderRole
    let text: String
    let attachments: [ChatAttachment]

    /// `nil` until the server stamps it. A message written offline (or one still in
    /// flight) is visible locally before Firestore has assigned a time — the UI must
    /// not invent one, or the row would jump when the real timestamp arrives.
    let createdAt: Date?

    /// True while the write is still only in the local cache. Drives the "sending"
    /// state; flips to false when the server acknowledges and the listener re-fires.
    let isPending: Bool

    var isOutgoing: Bool { senderRole == .user }

    /// A message with no text and no files is not worth rendering — it can only come
    /// from a malformed document.
    var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && attachments.isEmpty
    }
}
