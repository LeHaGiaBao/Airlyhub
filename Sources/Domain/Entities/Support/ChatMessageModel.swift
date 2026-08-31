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
    case user
    case agent
    case bot

    var isSupport: Bool { self != .user }
}

struct ChatAttachment: Equatable {
    let path: String
    let name: String
    let contentType: String
    let size: Int

    var isImage: Bool { contentType.hasPrefix("image/") }
}

struct ChatMessageModel: Equatable {
    let id: String
    let senderRole: MessageSenderRole
    let text: String
    let attachments: [ChatAttachment]

    let createdAt: Date?

    let isPending: Bool

    var isOutgoing: Bool { senderRole == .user }

    var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && attachments.isEmpty
    }
}
