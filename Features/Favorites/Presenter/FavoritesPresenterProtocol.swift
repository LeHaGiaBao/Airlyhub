//
//  FavoritesPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTab(at index: Int)
    func didSelectItem(id: String)
    /// The heart on a card in this list can only ever be un-hearted, so this is a
    /// removal rather than a toggle.
    func didRemoveFavorite(id: String)
}
