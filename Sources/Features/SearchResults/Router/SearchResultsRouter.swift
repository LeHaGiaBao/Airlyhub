//
//  SearchResultsRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class SearchResultsRouter: SearchResultsRouterProtocol {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    func showTourDetail(id: String) {
        let detail = TourDetailBuilder().build(tourID: id, nav: nav)
        detail.hidesBottomBarWhenPushed = true
        nav.pushViewController(detail, animated: true)
    }

    func presentSearchFilter(criteria: SearchCriteria,
                             onApply: @escaping (SearchCriteria) -> Void) {
        let sheet = SearchFilterBottomSheetViewController(criteria: criteria)
        sheet.onApply = onApply
        nav.topViewController?.present(sheet, animated: false)
    }

    func dismiss() {
        nav.popViewController(animated: true)
    }
}
