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

    func showTourDetail(id: String) {
        guard let nav = viewController?.navigationController else { return }
        let detail = TourDetailBuilder().build(tourID: id, nav: nav)
        detail.hidesBottomBarWhenPushed = true
        nav.pushViewController(detail, animated: true)
    }
}
