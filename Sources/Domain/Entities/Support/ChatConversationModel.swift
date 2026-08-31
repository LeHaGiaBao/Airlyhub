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
    case open
    case pending
    case closed
}

struct ChatConversationModel: Equatable {
    let id: String
    let status: ConversationStatus
    let lastMessage: String
    let lastMessageAt: Date?

    let createdAt: Date?
}
