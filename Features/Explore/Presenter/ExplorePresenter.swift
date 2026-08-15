//
//  ExplorePresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ExplorePresenter: ExplorePresenterProtocol {
    private weak var view: ExploreViewProtocol?
    private let interactor: ExploreInteractorProtocol
    private let router: ExploreRouterProtocol

    init(view: ExploreViewProtocol,
         interactor: ExploreInteractorProtocol,
         router: ExploreRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showHelpfulInformation(interactor.fetchHelpfulInformation())
    }

    func didSelectHelpfulInformation(_ item: HelpfulInformationItem) {
        router.presentHelpfulInformationDetail(item)
    }

    func didTapFindTour(location: LocationResult?, date: Date?, passengers: Int) {
        let criteria = SearchCriteria(
            type: .tour,
            origin: location,
            date: date,
            passengers: passengers
        )

        // Validation lives here rather than in the view: which fields a tour search
        // requires is a rule about searching, and the Flights screen answers it
        // differently for the same form.
        guard criteria.isComplete else {
            view?.showError(NSLocalizedString("search_incomplete", comment: ""))
            return
        }

        router.showSearchResults(SearchResultsContext(criteria: criteria))
    }
}
