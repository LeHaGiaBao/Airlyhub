//
//  TourDetailBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class TourDetailBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build(tourID: String, nav: UINavigationController) -> UIViewController {
        let view = TourDetailViewController()
        let interactor = TourDetailInteractor(
            tourRepository: container.tourRepository,
            favoritesRepository: container.favoritesRepository
        )
        let router = TourDetailRouter(nav: nav)
        let presenter = TourDetailPresenter(view: view,
                                            interactor: interactor,
                                            router: router,
                                            tourID: tourID)

        view.presenter = presenter
        return view
    }
}
