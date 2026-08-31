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
    let timeText: String
    let isOutgoing: Bool
    let isPending: Bool

    var hasText: Bool { !text.isEmpty }
}

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
    case loaded([ChatItem])
    case failed(String)
}

struct ChatAttachmentDraft {
    let data: Data
    let contentType: String
    let name: String
}

typealias ChatAttachmentLoader = (_ path: String, _ completion: @escaping (Data?) -> Void) -> Void

enum CustomerServiceError: LocalizedError, Equatable {
    case notAuthenticated
    case emptyMessage
    case messageTooLong
    case attachmentTooLarge
    case attachmentUploadFailed
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
                ChatPolicy.maxMessageLength
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
    static let maxAttachmentKilobytes = 512
    static let maxAttachmentBytes = maxAttachmentKilobytes * 1_024

    static let attachmentMaxDimension: CGFloat = 1_024
    static let attachmentJPEGQuality: CGFloat = 0.6
}
