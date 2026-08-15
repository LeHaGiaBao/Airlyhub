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

    /// Read-only catalog behind the Explore and Flights searches. Unowned — every
    /// signed-in user sees the same documents — and maintained in the Firebase
    /// console, mirroring `Resources/MockData/tours.seed.json`, so no client
    /// ever writes here.
    ///
    /// Documents use auto-ids and carry no `id` field; the record's identity is the
    /// `documentID`, which the seed file stands in for with its object keys. The
    /// two therefore differ between the mock and the server, so nothing may persist
    /// a tour id across a repository swap.
    static let tours = "tours"

    /// Support threads, one per user: the document id *is* the owner's uid.
    /// Ownership lives in the path here rather than in a field, which keeps the
    /// rules to a path comparison and means `messages` needs no composite index.
    static let conversations = "conversations"
    /// Subcollection of `conversations/{uid}`.
    static let messages = "messages"
}
