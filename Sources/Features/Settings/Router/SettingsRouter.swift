//
//  SettingsRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class SettingsRouter: SettingsRouterProtocol {
    weak var viewController: UIViewController?

    func presentLanguageSelection(languages: [AppLanguage],
                                  current: AppLanguage,
                                  onSelect: @escaping (AppLanguage) -> Void) {
        let sheet = LanguageSelectionBottomSheetViewController(languages: languages,
                                                               selected: current)
        sheet.onSelect = onSelect
        viewController?.present(sheet, animated: false)
    }

    func presentAboutUs() {
        let popup = AboutUsPopupViewController()
        viewController?.present(popup, animated: false)
    }

    func reloadForLanguageChange() {
        guard let window = viewController?.view.window else { return }
        let selectedTab = viewController?.tabBarController?.selectedIndex
        AppRouter.reloadRoot(in: window, selectedTab: selectedTab)
    }
}
