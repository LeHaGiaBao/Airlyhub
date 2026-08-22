//
//  TourReviewsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class TourReviewsPresenter: TourReviewsPresenterProtocol {
    private weak var view: TourReviewsViewProtocol?
    private let interactor: TourReviewsInteractorProtocol
    private let router: TourReviewsRouterProtocol
    private let reviews: [TourReviewModel]

    init(view: TourReviewsViewProtocol,
         interactor: TourReviewsInteractorProtocol,
         router: TourReviewsRouterProtocol,
         reviews: [TourReviewModel]) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.reviews = reviews
    }

    func viewDidLoad() {
        view?.showReviews(reviews)
    }

    func didTapBack() {
        router.dismiss()
    }
}
