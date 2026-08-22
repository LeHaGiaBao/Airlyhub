//
//  BookingRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The signed-in user's bookings, as the feature layer sees it.
///
/// Completions are called on the main queue, matching `TourRepositoryProtocol` and
/// `FavoritesRepositoryProtocol` — callers here drive UI directly.
protocol BookingRepositoryProtocol: AnyObject {
    /// Creates the booking and returns its id. Not the full `BookingModel`: the
    /// server stamps `createdAt`, which is unresolved until the next read — same
    /// reason `CardService.addCard` hands back only an id rather than a `CardModel`.
    func create(_ draft: BookingDraft,
               cardLast4: String?,
               cardBrand: CardBrand?,
               completion: @escaping (Result<String, Error>) -> Void)

    /// Newest first, matching how a ticket list reads.
    func fetchBookings(completion: @escaping (Result<[BookingModel], Error>) -> Void)
}
