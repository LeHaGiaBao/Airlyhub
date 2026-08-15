//
//  FavoritesRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class FavoritesRouter: FavoritesRouterProtocol {
    weak var viewController: UIViewController?

    /// No detail screen exists yet — same open end as `SearchResultsRouter`, left
    /// explicit so both tabs light up the moment that screen lands.
    func showTourDetail(id: String) {
        // TODO: push TourDetailBuilder().build(id:) once that screen exists.
    }
}
