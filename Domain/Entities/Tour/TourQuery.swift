//
//  TourQuery.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the search form on Explore or Flights asks the catalog for.
///
/// Explore fills in `originSlug` only; Flights fills in both ends. Everything is
/// optional apart from `type`, so an empty form still returns a browsable list
/// rather than nothing.
struct TourQuery {
    let type: TourType
    let originSlug: String?
    let destinationSlug: String?
    let date: Date?
    /// Party size from the passengers stepper. Matches records that seat at least
    /// this many.
    let minimumPassengers: Int?

    init(type: TourType,
         originSlug: String? = nil,
         destinationSlug: String? = nil,
         date: Date? = nil,
         minimumPassengers: Int? = nil) {
        self.type = type
        self.originSlug = originSlug
        self.destinationSlug = destinationSlug
        self.date = date
        self.minimumPassengers = minimumPassengers
    }
}

/// Opaque marker for "resume after this record".
///
/// Not a page number: Firestore pages with `start(afterDocument:)` and has no
/// offset-based skip, so a caller must hand back the value the repository gave it
/// rather than compute the next one. Each implementation defines its own concrete
/// type — the domain never looks inside.
protocol TourCursor {}

struct TourPage {
    let items: [TourModel]
    /// Pass to the next `search` call to fetch the following page.
    /// `nil` means the result set is exhausted — hide "Show more".
    let cursor: TourCursor?

    var hasMore: Bool { cursor != nil }
}
