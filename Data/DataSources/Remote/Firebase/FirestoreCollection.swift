//
//  FirestoreCollection.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation

struct FirestoreCollection {
    static let users = "users"
    /// Top-level collection. Ownership is carried by each document's `userId`
    /// field rather than by the path — see `CardService`.
    static let cards = "cards"

    /// Support threads, one per user: the document id *is* the owner's uid.
    /// Ownership lives in the path here rather than in a field, which keeps the
    /// rules to a path comparison and means `messages` needs no composite index.
    static let conversations = "conversations"
    /// Subcollection of `conversations/{uid}`.
    static let messages = "messages"
}
