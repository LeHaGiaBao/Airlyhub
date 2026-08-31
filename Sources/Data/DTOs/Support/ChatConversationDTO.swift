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
