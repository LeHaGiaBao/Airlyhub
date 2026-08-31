//
//  FavoritesTab.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The two pills at the top of Favorites.
enum FavoritesTab: Int, CaseIterable {
    case tours
    case flights

    var tourType: TourType {
        switch self {
        case .tours: return .tour
        case .flights: return .flight
        }
    }

    var title: String {
        switch self {
        case .tours: return NSLocalizedString("favorites_tab_tours", comment: "")
        case .flights: return NSLocalizedString("favorites_tab_flights", comment: "")
        }
    }

    var emptyMessage: String {
        switch self {
        case .tours: return NSLocalizedString("favorites_empty_tours", comment: "")
        case .flights: return NSLocalizedString("favorites_empty_flights", comment: "")
        }
    }
}
