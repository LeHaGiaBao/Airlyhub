//
//  TourReviewsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class TourReviewsBuilder {
    /// Reviews are injected rather than fetched — the detail screen already holds
    /// them, and a lookup here would only re-fetch what got the user to this
    /// screen. Mirrors `MyTicketDetailBuilder.build(ticket:)`.
    func build(reviews: [TourReviewModel], nav: UINavigationController) -> UIViewController {
        let view = TourReviewsViewController()
        let interactor = TourReviewsInteractor()
        let router = TourReviewsRouter(nav: nav)
        let presenter = TourReviewsPresenter(view: view,
                                             interactor: interactor,
                                             router: router,
                                             reviews: reviews)

        view.presenter = presenter
        return view
    }
}
