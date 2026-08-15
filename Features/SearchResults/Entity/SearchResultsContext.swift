//
//  SearchResultsContext.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Everything one run of the results screen needs.
///
/// A thin wrapper over `SearchCriteria`: every display decision is derived from the
/// criteria rather than stored beside them, so applying a filter is a single
/// assignment and the header, the query and the rail cannot fall out of step.
///
/// The two entry points differ only in what they put in the criteria — Explore
/// searches tours from a single place and shows a "Popular" rail, Flights searches
/// point-to-point and shows a price on every card. Bundling that as data is what
/// lets one screen serve both instead of two near-identical ones.
struct SearchResultsContext {
    var criteria: SearchCriteria

    var query: TourQuery { criteria.query }

    /// Text in the header pill, e.g. "St. Petersburg, July 30".
    var summary: String { criteria.summary }

    /// Heading above the list.
    var sectionTitle: String {
        switch criteria.type {
        case .tour:
            return NSLocalizedString("air_tours", comment: "")
        case .flight:
            return NSLocalizedString("search_results", comment: "")
        }
    }

    /// Explore only. Flights results go straight into the list.
    var showsPopular: Bool { criteria.type == .tour }
}
