//
//  SearchCriteria.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the user typed into a search form, before it becomes a query.
struct SearchCriteria {
    let type: TourType
    var origin: LocationResult?
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

    var isComplete: Bool {
        guard origin != nil, date != nil else { return false }
        return type == .tour || destination != nil
    }
}

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

    var summary: String {
        let route = [origin?.city, destination?.city]
            .compactMap { $0 }
            .joined(separator: " - ")

        var pieces: [String] = []
        if !route.isEmpty { pieces.append(route) }
        if let date { pieces.append(TourFormatter.summaryDate(date)) }

        return pieces.isEmpty
            ? NSLocalizedString("search_results", comment: "")
            : pieces.joined(separator: ", ")
    }
}
