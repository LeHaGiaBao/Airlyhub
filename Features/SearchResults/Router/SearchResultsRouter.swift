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

    /// No detail screen exists yet. Left as an explicit no-op rather than wiring the
    /// tap to nothing, so the missing destination is visible here instead of looking
    /// like a dead card in the list.
    func showTourDetail(id: String) {
        // TODO: push TourDetailBuilder().build(id:) once that screen exists.
    }

    // `BaseBottomSheetViewController` presents over full screen and runs its own
    // slide-in, so `animated` stays false — UIKit's transition would double it up.
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
