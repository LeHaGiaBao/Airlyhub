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
///
/// Any attachment here has already been uploaded; `ChatAttachment.path` points at
/// the stored bytes. Building the Firestore document from this is the repository's
/// job, so the interactor never touches a `Data` DTO.
struct OutgoingChatMessage {
    let text: String
    let attachments: [ChatAttachment]

    init(text: String, attachments: [ChatAttachment] = []) {
        self.text = text
        self.attachments = attachments
    }
}
