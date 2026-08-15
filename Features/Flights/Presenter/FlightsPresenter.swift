//
//  FlightsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class FlightsPresenter: FlightsPresenterProtocol {
    private weak var view: FlightsViewProtocol?
    private let interactor: FlightsInteractorProtocol
    private let router: FlightsRouterProtocol

    init(view: FlightsViewProtocol,
         interactor: FlightsInteractorProtocol,
         router: FlightsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {}

    /// Only the departure date reaches the query. The catalog carries no schedule
    /// yet, so a return date has nothing to filter against — the form keeps it for
    /// when `departures` exists.
    func didTapFind(from origin: LocationResult?,
                    to destination: LocationResult?,
                    date: Date?,
                    passengers: Int) {
        let criteria = SearchCriteria(
            type: .flight,
            origin: origin,
            destination: destination,
            date: date,
            passengers: passengers
        )

        // A flight needs both ends, which is where this differs from Explore —
        // `SearchCriteria.isComplete` keeps that rule in one place.
        guard criteria.isComplete else {
            view?.showError(NSLocalizedString("search_incomplete", comment: ""))
            return
        }

        router.showSearchResults(SearchResultsContext(criteria: criteria))
    }
}
