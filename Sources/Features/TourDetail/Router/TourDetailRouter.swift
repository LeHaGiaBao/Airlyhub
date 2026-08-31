//
//  TourDetailRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class TourDetailRouter: TourDetailRouterProtocol {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    func dismiss() {
        nav.popViewController(animated: true)
    }

    func showAllReviews(_ reviews: [TourReviewModel]) {
        let view = TourReviewsBuilder().build(reviews: reviews, nav: nav)
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
    }

    func startBooking(_ draft: BookingDraft) {
        let view = CheckoutBuilder().build(draft: draft, nav: nav)
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
    }
}
