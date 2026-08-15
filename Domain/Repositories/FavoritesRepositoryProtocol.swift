//
//  FavoritesRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The user's saved tours, as the feature layer sees it.
///
/// Separate from `TourRepositoryProtocol` on purpose: the catalog is shared and
/// read-only, while this is per-user and written to. When favourites move to
/// Firestore they land under the signed-in user's document rather than in `tours`,
/// so the two would not have shared a backing store anyway.
///
/// Completions are called on the main queue, matching the other repositories —
/// callers here drive UI directly.
protocol FavoritesRepositoryProtocol: AnyObject {
    /// Saved records of one kind, in catalog order.
    ///
    /// Returns whole `TourModel`s rather than ids so the screen does not have to
    /// resolve each id against the catalog itself — a lookup that would be a second
    /// round trip once this is backed by a real store.
    func favorites(ofType type: TourType,
                   completion: @escaping (Result<[TourModel], Error>) -> Void)

    func isFavorite(tourID: String) -> Bool

    /// Writes through immediately; there is no completion because every caller
    /// updates its own UI optimistically and has nothing to do with the result.
    func setFavorite(_ isFavorite: Bool, tourID: String)
}
