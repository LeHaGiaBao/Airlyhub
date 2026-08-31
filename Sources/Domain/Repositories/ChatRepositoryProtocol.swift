//
//  ChatRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The support thread at `conversations/{uid}`, as the feature layer sees it.
protocol ChatRepositoryProtocol: AnyObject {
    func loadOrCreateConversation(uid: String,
                                  userName: String?,
                                  userEmail: String?,
                                  completion: @escaping (Result<ChatConversationModel, Error>) -> Void)

    func observeMessages(uid: String,
                         onChange: @escaping (Result<[ChatMessageModel], Error>) -> Void) -> ChatSubscription

    func sendMessage(uid: String,
                     _ message: OutgoingChatMessage,
                     completion: @escaping (Result<Void, Error>) -> Void)
}
