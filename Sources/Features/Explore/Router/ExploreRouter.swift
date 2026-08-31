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

    func presentHelpfulInformationDetail(_ item: HelpfulInformationItem) {
        let sheet = HelpfulInfoDetailSheetViewController(item: item)
        nav.topViewController?.present(sheet, animated: false)
    }

    func showSearchResults(_ context: SearchResultsContext) {
        let view = SearchResultsBuilder().build(context: context, nav: nav)
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
    }
}
