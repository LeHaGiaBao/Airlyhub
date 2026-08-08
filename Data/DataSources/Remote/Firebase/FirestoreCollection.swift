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
}
