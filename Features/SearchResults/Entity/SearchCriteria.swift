//
//  SearchCriteria.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the user typed into a search form, before it becomes a query.
///
/// Kept as the raw `LocationResult` rather than only the derived `TourQuery`,
/// because the filter sheet reopens the form and has to show what was chosen —
/// and a slug cannot be turned back into a city name.
struct SearchCriteria {
    let type: TourType
    var origin: LocationResult?
    /// Flights only. A tour departs from and returns to the same airfield.
    var destination: LocationResult?
    var date: Date?
    var passengers: Int

    init(type: TourType,
         origin: LocationResult? = nil,
         destination: LocationResult? = nil,
         date: Date? = nil,
         passengers: Int = 1) {
        self.type = type
        self.origin = origin
        self.destination = destination
        self.date = date
        self.passengers = passengers
    }

    /// Whether the form has enough to search on.
    ///
    /// `passengers` is not checked: the stepper starts at 1 and cannot go lower, so
    /// it is never empty. A flight needs both ends; a tour needs only the one.
    var isComplete: Bool {
        guard origin != nil, date != nil else { return false }
        return type == .tour || destination != nil
    }
}

// MARK: - Mapping
extension SearchCriteria {
    var query: TourQuery {
        TourQuery(
            type: type,
            originSlug: origin.map(TourSlug.make(from:)),
            destinationSlug: destination.map(TourSlug.make(from:)),
            date: date,
            minimumPassengers: passengers
        )
    }

    /// Text in the header pill: "St. Petersburg, July 30" or
    /// "Novosibirsk - Baikal, July 30".
    var summary: String {
        let route = [origin?.city, destination?.city]
            .compactMap { $0 }
            .joined(separator: " - ")

        var pieces: [String] = []
        if !route.isEmpty { pieces.append(route) }
        if let date { pieces.append(TourFormatter.summaryDate(date)) }

        // A complete form always fills both, but the fallback keeps the header from
        // collapsing to an empty pill if that ever stops being true.
        return pieces.isEmpty
            ? NSLocalizedString("search_results", comment: "")
            : pieces.joined(separator: ", ")
    }
}
