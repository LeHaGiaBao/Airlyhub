//
//  SearchResultsViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SearchResultsViewProtocol: AnyObject {
    /// Header text and section heading — set once, on load.
    func showHeader(summary: String, sectionTitle: String)
    /// Just the pill text, after a filter changed the criteria. Separate from
    /// `showHeader` so re-applying does not also reset the "Popular" panel.
    func updateSummary(_ summary: String)

    func showLoading(_ isLoading: Bool)
    /// Replaces the list; a fresh search.
    func showResults(_ items: [TourCardModel], hasMore: Bool)
    /// Appends the next page.
    func appendResults(_ items: [TourCardModel], hasMore: Bool)
    func showPopular(_ items: [TourCardModel])
    /// Flips one heart in place, without re-rendering the list.
    func setFavorite(_ isFavorite: Bool, forItemID id: String)
    func setLoadingMore(_ isLoading: Bool)
    func showError(_ message: String)
}
