//
//  SearchResultsContext.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// Everything one run of the results screen needs.
struct SearchResultsContext {
    var criteria: SearchCriteria

    var query: TourQuery { criteria.query }

    var summary: String { criteria.summary }

    var sectionTitle: String {
        switch criteria.type {
        case .tour:
            return NSLocalizedString("air_tours", comment: "")
        case .flight:
            return NSLocalizedString("search_results", comment: "")
        }
    }

    var showsPopular: Bool { criteria.type == .tour }
}
