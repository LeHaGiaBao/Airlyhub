//
//  ChatConversationModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Where a support thread stands. Only an operator moves it away from `open`;
/// the app reads this but never writes it.
enum ConversationStatus: String, Codable {
    /// Waiting on support.
    case open
    /// An operator has picked it up.
    case pending
    /// Resolved.
    case closed
}

/// The support thread's header document — `conversations/{uid}`.
///
/// Everything here except `createdAt` is denormalized from the newest message so an
/// operator's inbox can sort and preview threads by reading one document each instead
/// of walking every `messages` subcollection.
struct ChatConversationModel: Equatable {
    let id: String
    let status: ConversationStatus
    let lastMessage: String
    let lastMessageAt: Date?

    /// When the user first opened the screen. The canned greeting is anchored to this
    /// so it sits above every real message instead of floating at "now".
    let createdAt: Date?
}
