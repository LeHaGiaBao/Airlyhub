//
//  SearchResultsViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol SearchResultsViewProtocol: AnyObject {
    func showHeader(summary: String, sectionTitle: String)
    func updateSummary(_ summary: String)

    func showLoading(_ isLoading: Bool)
    func showResults(_ items: [TourCardModel], hasMore: Bool)
    func appendResults(_ items: [TourCardModel], hasMore: Bool)
    func showPopular(_ items: [TourCardModel])
    func setFavorite(_ isFavorite: Bool, forItemID id: String)
    func setLoadingMore(_ isLoading: Bool)
    func showError(_ message: String)
}
