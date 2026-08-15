//
//  TourType.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Which of the two search flows a record belongs to.
///
/// Both live in one `tours` collection and render through the same card, so the
/// type is a stored field rather than a separate collection — it keeps the
/// repository to a single query shape and the UI to a single component.
enum TourType: String, Codable {
    /// Sightseeing flight sold as an experience. Explore searches these; they have
    /// no destination and their price is not shown on the card.
    case tour
    /// Point-to-point flight with a per-passenger price. Flights searches these.
    case flight
}
