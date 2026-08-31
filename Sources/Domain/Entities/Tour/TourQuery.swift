//
//  TourQuery.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the search form on Explore or Flights asks the catalog for.
struct TourQuery {
    let type: TourType
    let originSlug: String?
    let destinationSlug: String?
    let date: Date?
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

protocol TourCursor {}

struct TourPage {
    let items: [TourModel]
    let cursor: TourCursor?

    var hasMore: Bool { cursor != nil }
}
