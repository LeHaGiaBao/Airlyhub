//
//  SearchResultsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class SearchResultsBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build(context: SearchResultsContext, nav: UINavigationController) -> UIViewController {
        let view = SearchResultsViewController()
        let interactor = SearchResultsInteractor(repository: container.tourRepository)
        let router = SearchResultsRouter(nav: nav)
        let presenter = SearchResultsPresenter(view: view,
                                               interactor: interactor,
                                               router: router,
                                               context: context)

        view.presenter = presenter
        return view
    }
}
