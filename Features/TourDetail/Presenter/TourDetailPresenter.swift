//
//  TourDetailPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class TourDetailPresenter: TourDetailPresenterProtocol {
    private weak var view: TourDetailViewProtocol?
    private let interactor: TourDetailInteractorProtocol
    private let router: TourDetailRouterProtocol
    private let tourID: String

    private var detail: TourDetailModel?
    private var selection = TourDetailSelection()
    private var isFavorite = false

    init(view: TourDetailViewProtocol,
         interactor: TourDetailInteractorProtocol,
         router: TourDetailRouterProtocol,
         tourID: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.tourID = tourID
    }

    func viewDidLoad() {
        isFavorite = interactor.isFavorite(tourID: tourID)

        view?.showLoading(true)
        interactor.loadDetail(id: tourID) { [weak self] result in
            guard let self else { return }
            self.view?.showLoading(false)

            switch result {
            case .success(let detail?):
                self.detail = detail
                self.selection.passengers = min(self.selection.passengers, detail.maxPassengers)
                self.render()
            case .success(nil), .failure:
                // No record for this id and a network failure look the same to the
                // user here — either way there is nothing to show.
                self.view?.showError(NSLocalizedString("tour_detail_load_failed", comment: ""))
            }
        }
    }

    func didTapBack() {
        router.dismiss()
    }

    func didToggleFavorite() {
        isFavorite.toggle()
        interactor.setFavorite(isFavorite, tourID: tourID)
        render()
    }

    func didSelectDuration(index: Int) {
        selection.durationIndex = index
        render()
    }

    func didSelectDepartureTime(index: Int) {
        selection.departureTimeIndex = index
        render()
    }

    func didChangePassengers(_ count: Int) {
        guard let detail else { return }
        selection.passengers = min(max(count, 1), detail.maxPassengers)
        render()
    }

    func didSelectDate(_ date: Date) {
        selection.date = date
        render()
    }

    func didTapAllReviews() {
        router.showAllReviews(tourID: tourID)
    }

    func didTapBook() {
        router.startBooking(tourID: tourID, selection: selection)
    }

    // MARK: - Rendering

    /// The one place a `TourDetailViewModel` is built, so the header, the price and
    /// every pill row are always derived from the same `detail` + `selection` pair
    /// and cannot go out of step with each other.
    private func render() {
        guard let detail else { return }
        view?.render(TourDetailViewModel(detail: detail, selection: selection, isFavorite: isFavorite))
    }
}
