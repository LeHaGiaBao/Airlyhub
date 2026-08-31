//
//  ChatMessageDTO.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// Firestore representation of `conversations/{uid}/messages/{messageId}`.
struct ChatMessageDTO: Codable {
    let senderId: String?
    let senderRole: String
    let text: String
    let attachments: [ChatAttachmentDTO]?

    @ServerTimestamp var createdAt: Timestamp?
}

struct ChatAttachmentDTO: Codable {
    let path: String
    let name: String
    let contentType: String
    let size: Int
}

extension ChatMessageDTO {
    func toDomain(id: String, isPending: Bool) -> ChatMessageModel {
        ChatMessageModel(
            id: id,
            senderRole: MessageSenderRole(rawValue: senderRole) ?? .agent,
            text: text,
            attachments: attachments?.map { $0.toDomain() } ?? [],
            createdAt: createdAt?.dateValue(),
            isPending: isPending
        )
    }

    static func make(senderId: String,
                     text: String,
                     attachments: [ChatAttachmentDTO] = []) -> ChatMessageDTO {
        ChatMessageDTO(
            senderId: senderId,
            senderRole: MessageSenderRole.user.rawValue,
            text: text,
            attachments: attachments.isEmpty ? nil : attachments,
            createdAt: nil
        )
    }
}

extension ChatAttachmentDTO {
    func toDomain() -> ChatAttachment {
        ChatAttachment(path: path, name: name, contentType: contentType, size: size)
    }

    init(_ attachment: ChatAttachment) {
        self.init(path: attachment.path,
                  name: attachment.name,
                  contentType: attachment.contentType,
                  size: attachment.size)
    }
}
