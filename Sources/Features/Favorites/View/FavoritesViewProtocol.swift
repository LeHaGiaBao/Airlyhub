//
//  FavoritesViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func showTabs(titles: [String], selectedIndex: Int)
    func showLoading(_ isLoading: Bool)
    func showItems(_ items: [TourCardModel], emptyMessage: String)
    func showError(_ message: String)
}
