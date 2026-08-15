//
//  CustomerServiceInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol CustomerServiceInteractorProtocol: AnyObject {
    /// Creates the thread if this is the user's first visit, then emits its header.
    func loadConversation() -> Observable<ChatConversationModel>

    /// Long-lived stream of the thread. Emits on every change — including the user's own
    /// message the instant it hits the local cache — and only completes when disposed.
    func observeMessages() -> Observable<[ChatMessageModel]>

    /// Uploads `attachment` if present, then writes the message.
    func sendMessage(text: String, attachment: ChatAttachmentDraft?) -> Observable<Void>
}
