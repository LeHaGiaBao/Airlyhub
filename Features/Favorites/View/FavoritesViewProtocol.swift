//
//  FavoritesViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    /// Builds the pill row. Called once, on load — the tabs never change afterwards.
    func showTabs(titles: [String], selectedIndex: Int)
    func showLoading(_ isLoading: Bool)
    /// Replaces the list.
    /// - Parameter emptyMessage: shown instead of the cards when `items` is empty;
    ///   it is worded per tab, so it arrives with the content rather than being
    ///   fixed when the view is built.
    func showItems(_ items: [TourCardModel], emptyMessage: String)
    func showError(_ message: String)
}
