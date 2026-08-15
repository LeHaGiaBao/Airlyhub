//
//  ExploreRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class ExploreRouter: ExploreRouterProtocol {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    // `BaseBottomSheetViewController` presents itself over full screen and runs its own
    // slide-in, so `animated` stays false here — UIKit's transition would double it up.
    func presentHelpfulInformationDetail(_ item: HelpfulInformationItem) {
        let sheet = HelpfulInfoDetailSheetViewController(item: item)
        nav.topViewController?.present(sheet, animated: false)
    }

    func showSearchResults(_ context: SearchResultsContext) {
        let view = SearchResultsBuilder().build(context: context, nav: nav)
        // The results are a drill-down, not a tab: hiding the bar gives the list the
        // full height and matches how Profiles pushes its sub-screens.
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
    }
}
