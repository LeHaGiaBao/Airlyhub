//
//  TourRepositoryProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The catalog, as the feature layer sees it.
///
/// The point of this protocol is that swapping the backing store is a one-line
/// change in the builder: `MockTourRepository` reads a bundled JSON today, a
/// Firestore implementation reads `tours` tomorrow, and neither the presenter nor
/// the card knows the difference.
///
/// Completions are called on the main queue, matching `RemoteLocationService` and
/// `CardService` — callers here drive UI directly.
protocol TourRepositoryProtocol: AnyObject {
    /// One page of results. Pass the previous page's `cursor` to continue;
    /// `nil` starts over from the top.
    func search(_ query: TourQuery,
                after cursor: TourCursor?,
                completion: @escaping (Result<TourPage, Error>) -> Void)

    /// Curated rail for the Explore carousel — records tagged `popular`.
    func popular(type: TourType,
                 limit: Int,
                 completion: @escaping (Result<[TourModel], Error>) -> Void)
}
