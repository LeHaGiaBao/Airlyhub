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

    /// No reviews list screen exists yet — left as an explicit no-op, the same way
    /// `SearchResultsRouter.showTourDetail` marked this screen's own absence before
    /// it existed.
    func showAllReviews(tourID: String) {
        // TODO: push a ReviewsListBuilder().build(tourID:) once that screen exists.
    }

    /// No booking flow exists yet.
    func startBooking(tourID: String, selection: TourDetailSelection) {
        // TODO: push a BookingBuilder().build(tourID:selection:) once that flow exists.
    }
}
