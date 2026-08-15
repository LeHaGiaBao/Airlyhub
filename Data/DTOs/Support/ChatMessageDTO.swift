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
///
/// The field set is mirrored by the security rules' whitelist. `senderRole` in
/// particular is checked against the caller's auth token server-side, so writing
/// `agent` from the app is rejected rather than trusted.
struct ChatMessageDTO: Codable {
    /// Optional on read only. The app always writes it and the rules require it to match
    /// the caller, but an operator replying by hand in the Firebase console bypasses the
    /// rules and can leave it out — and a required field would make that whole message
    /// fail to decode and vanish from the thread rather than merely lack an author.
    let senderId: String?
    let senderRole: String
    let text: String
    let attachments: [ChatAttachmentDTO]?

    /// Left nil on write so Firestore stamps the server clock. The rules require this
    /// to equal `request.time`, which is what stops a client from back-dating a message
    /// into the middle of the thread.
    @ServerTimestamp var createdAt: Timestamp?
}

/// Metadata for one uploaded file. Only this descriptor is written to Firestore; the
/// bytes sit in Realtime Database at `path`, base64-encoded — see `ChatAttachmentService`
/// for why they don't live in the message itself.
struct ChatAttachmentDTO: Codable {
    /// RTDB node holding the payload, e.g. `chatAttachments/{uid}/{attachmentId}`.
    /// Stored whole rather than as an id so a reader needs no knowledge of the layout.
    let path: String
    let name: String
    let contentType: String
    /// Size of the original bytes, before base64 expanded them by roughly a third.
    let size: Int
}

// MARK: - Mapping
extension ChatMessageDTO {
    /// - Parameter isPending: `snapshot.metadata.hasPendingWrites` — true while the write
    ///   exists only in the local cache. Passed in rather than derived because the DTO
    ///   never sees the snapshot it came from.
    func toDomain(id: String, isPending: Bool) -> ChatMessageModel {
        ChatMessageModel(
            id: id,
            // An unrecognised role is treated as support: it renders on the left and
            // gets no "you sent this" affordances, which is the safe way to be wrong.
            senderRole: MessageSenderRole(rawValue: senderRole) ?? .agent,
            text: text,
            attachments: attachments?.map { $0.toDomain() } ?? [],
            createdAt: createdAt?.dateValue(),
            isPending: isPending
        )
    }

    /// Builds the document for a message the user is sending.
    /// `createdAt` is deliberately nil — see the property's note.
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
}
