//
//  ChatConversationDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Firestore representation of `conversations/{uid}`.
///
/// The document id *is* the owner's uid, so there is no ownership field to check —
/// the rules compare `request.auth.uid` against the path directly. That is also why
/// queries here need no composite index, unlike `cards`.
struct ChatConversationDTO: Codable {
    let userId: String
    let userName: String?
    let userEmail: String?
    let status: String
    let lastMessage: String
    let lastSenderRole: String

    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var lastMessageAt: Timestamp?
}

// MARK: - Mapping
extension ChatConversationDTO {
    func toDomain(id: String) -> ChatConversationModel {
        ChatConversationModel(
            id: id,
            status: ConversationStatus(rawValue: status) ?? .open,
            lastMessage: lastMessage,
            lastMessageAt: lastMessageAt?.dateValue(),
            createdAt: createdAt?.dateValue()
        )
    }

    /// The document created the first time a user opens the support screen.
    static func make(userId: String, userName: String?, userEmail: String?) -> ChatConversationDTO {
        ChatConversationDTO(
            userId: userId,
            userName: userName,
            userEmail: userEmail,
            status: ConversationStatus.open.rawValue,
            lastMessage: "",
            lastSenderRole: "",
            createdAt: nil,
            lastMessageAt: nil
        )
    }
}
