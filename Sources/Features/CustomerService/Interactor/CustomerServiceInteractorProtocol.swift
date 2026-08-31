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
    func loadConversation() -> Observable<ChatConversationModel>

    func observeMessages() -> Observable<[ChatMessageModel]>

    func sendMessage(text: String, attachment: ChatAttachmentDraft?) -> Observable<Void>
}
