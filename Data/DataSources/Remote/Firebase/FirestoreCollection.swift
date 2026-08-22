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
    /// console, so no client ever writes here.
    ///
    /// Nothing reads this today: the app renders from `TourMockData` and
    /// `TourService` is not wired into any builder. Documents would use auto-ids
    /// and carry no `id` field, the record's identity being the `documentID` —
    /// which differs from the mock's ids, so nothing may persist a tour id across
    /// a repository swap.
    static let tours = "tours"

    /// Support threads, one per user: the document id *is* the owner's uid.
    /// Ownership lives in the path here rather than in a field, which keeps the
    /// rules to a path comparison and means `messages` needs no composite index.
    static let conversations = "conversations"
    /// Subcollection of `conversations/{uid}`.
    static let messages = "messages"

    /// Top-level collection, same reasoning as `cards`: ownership is each
    /// document's `userId` field rather than the path — see `BookingService`.
    static let bookings = "bookings"
}
