//
//  ChatRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The support thread at `conversations/{uid}`, as the feature layer sees it.
///
/// Unlike the other repositories this one *listens*: `observeMessages` returns a
/// `ChatSubscription` the caller must `remove()` when the screen goes away.
protocol ChatRepositoryProtocol: AnyObject {
    /// Fetches the thread header, creating it on first visit. `userName` / `userEmail`
    /// are copied onto the thread so an operator sees who they're talking to.
    func loadOrCreateConversation(uid: String,
                                  userName: String?,
                                  userEmail: String?,
                                  completion: @escaping (Result<ChatConversationModel, Error>) -> Void)

    /// Long-lived stream of the newest messages, oldest-first; re-fires on every
    /// change and never completes on its own. `remove()` the returned handle to stop it.
    func observeMessages(uid: String,
                         onChange: @escaping (Result<[ChatMessageModel], Error>) -> Void) -> ChatSubscription

    /// Builds and writes the message document. Firestore applies it to the local
    /// cache immediately, so `observeMessages` fires before this completion — which
    /// reports the *server* outcome only.
    func sendMessage(uid: String,
                     _ message: OutgoingChatMessage,
                     completion: @escaping (Result<Void, Error>) -> Void)
}
