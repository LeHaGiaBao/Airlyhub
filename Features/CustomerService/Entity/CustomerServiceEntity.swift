//
//  CustomerServiceEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// One bubble, already formatted. The view never touches a `Date` or a raw model.
struct ChatBubbleItem: Equatable {
    let id: String
    let text: String
    let attachments: [ChatAttachment]
    /// Empty while the message has no timestamp yet, which hides the label rather
    /// than showing a placeholder that would shift the layout when it fills in.
    let timeText: String
    let isOutgoing: Bool
    /// Written locally but not yet acknowledged by the server.
    let isPending: Bool

    var hasText: Bool { !text.isEmpty }
}

/// A row in the thread. Day separators are rows rather than section headers so the
/// table stays a single flat list — simpler to diff and to keep pinned to the bottom.
enum ChatItem: Equatable {
    case daySeparator(id: String, title: String)
    case message(ChatBubbleItem)

    var id: String {
        switch self {
        case .daySeparator(let id, _): return id
        case .message(let item): return item.id
        }
    }
}

enum CustomerServiceViewState: Equatable {
    case loading
    /// Never empty in practice — the greeting is always the first row.
    case loaded([ChatItem])
    case failed(String)
}

/// A file the user picked, already downscaled and encoded, on its way to the database.
struct ChatAttachmentDraft {
    let data: Data
    let contentType: String
    let name: String
}

enum CustomerServiceError: LocalizedError, Equatable {
    case notAuthenticated
    case emptyMessage
    case messageTooLong
    case attachmentTooLarge
    case attachmentUploadFailed
    /// Realtime Database isn't configured for this build, so there is nowhere to put
    /// the bytes. Text still works, which is why this doesn't disable the whole screen.
    case attachmentsUnavailable

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return NSLocalizedString("error_not_authenticated", comment: "")
        case .emptyMessage:
            return NSLocalizedString("chat_error_empty_message", comment: "")
        case .messageTooLong:
            return String(
                format: NSLocalizedString("chat_error_message_too_long", comment: ""),
                ChatService.maxMessageLength
            )
        case .attachmentTooLarge:
            return String(
                format: NSLocalizedString("chat_error_attachment_too_large", comment: ""),
                CustomerServiceLimits.maxAttachmentKilobytes
            )
        case .attachmentUploadFailed:
            return NSLocalizedString("chat_error_attachment_failed", comment: "")
        case .attachmentsUnavailable:
            return NSLocalizedString("chat_error_attachment_unavailable", comment: "")
        }
    }
}

enum CustomerServiceLimits {
    /// Attachments go to Realtime Database as base64, which is roughly a third larger
    /// than the bytes it encodes — so this cap costs about 700 KB of the free plan's
    /// 1 GB, and a whole photo has to be downloaded to be seen at all. Far tighter than
    /// a Cloud Storage budget would justify, and deliberately so.
    static let maxAttachmentKilobytes = 512
    static let maxAttachmentBytes = maxAttachmentKilobytes * 1_024

    /// Longest edge an attached photo is resized to. Sized to land under the cap for a
    /// typical camera photo; a support screenshot stays legible well below this.
    static let attachmentMaxDimension: CGFloat = 1_024
    static let attachmentJPEGQuality: CGFloat = 0.6
}
