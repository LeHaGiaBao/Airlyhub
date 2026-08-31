//
//  OutgoingChatMessage.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// A message the user is sending, in domain terms — the input to
/// `ChatRepositoryProtocol.sendMessage`.
struct OutgoingChatMessage {
    let text: String
    let attachments: [ChatAttachment]

    init(text: String, attachments: [ChatAttachment] = []) {
        self.text = text
        self.attachments = attachments
    }
}
