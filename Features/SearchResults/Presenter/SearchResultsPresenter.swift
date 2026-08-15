//
//  SearchResultsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class SearchResultsPresenter: SearchResultsPresenterProtocol {
    private weak var view: SearchResultsViewProtocol?
    private let interactor: SearchResultsInteractorProtocol
    private let router: SearchResultsRouterProtocol
    /// Mutable: the filter sheet replaces the criteria in place, and everything the
    /// screen shows is derived from them.
    private var context: SearchResultsContext

    /// Cursor for the next page, `nil` once the results are exhausted.
    private var cursor: TourCursor?
    /// Guards against a second page request while one is already in flight — the
    /// button is disabled too, but a fast double tap can slip between the two.
    private var isLoadingMore = false
    /// Ids the user has hearted this session. Not persisted yet: `TourService`
    /// documents use auto-ids, so anything stored now would not survive a swap
    /// between the mock and Firestore.
    private var favorites: Set<String> = []

    init(view: SearchResultsViewProtocol,
         interactor: SearchResultsInteractorProtocol,
         router: SearchResultsRouterProtocol,
         context: SearchResultsContext) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.context = context
    }

    func viewDidLoad() {
        // No `showsPopular` flag: the rail's panel stays hidden until `showPopular`
        // arrives with something to put in it, and `loadPopular` only runs for the
        // searches that have one. One source of truth beats two.
        view?.showHeader(summary: context.summary, sectionTitle: context.sectionTitle)

        loadFirstPage()

        if context.showsPopular {
            loadPopular()
        }
    }

    func didTapShowMore() {
        guard let cursor, !isLoadingMore else { return }

        isLoadingMore = true
        view?.setLoadingMore(true)

        interactor.search(context.query, after: cursor) { [weak self] result in
            guard let self else { return }
            self.isLoadingMore = false
            self.view?.setLoadingMore(false)

            switch result {
            case .success(let page):
                self.cursor = page.cursor
                self.view?.appendResults(self.cards(from: page.items), hasMore: page.hasMore)
            case .failure:
                // The pages already on screen stay; only the new one failed, so a
                // toast is the right size of complaint.
                self.view?.showError(NSLocalizedString("tour_search_failed", comment: ""))
            }
        }
    }

    func didTapFilter() {
        router.presentSearchFilter(criteria: context.criteria) { [weak self] criteria in
            guard let self else { return }
            self.context.criteria = criteria
            self.view?.updateSummary(self.context.summary)
            // A new query invalidates the cursor — keeping it would page the old
            // search's results in underneath the new ones.
            self.cursor = nil
            self.loadFirstPage()
        }
    }

    func didSelectItem(id: String) {
        router.showTourDetail(id: id)
    }

    func didToggleFavorite(id: String) {
        let isFavorite = !favorites.contains(id)
        if isFavorite {
            favorites.insert(id)
        } else {
            favorites.remove(id)
        }
        view?.setFavorite(isFavorite, forItemID: id)
    }

    func didTapBack() {
        router.dismiss()
    }

    // MARK: - Loading

    private func loadFirstPage() {
        view?.showLoading(true)

        interactor.search(context.query, after: nil) { [weak self] result in
            guard let self else { return }
            self.view?.showLoading(false)

            switch result {
            case .success(let page):
                self.cursor = page.cursor
                self.view?.showResults(self.cards(from: page.items), hasMore: page.hasMore)
            case .failure:
                // An empty list plus a toast, rather than a blank screen that looks
                // like a search with no matches.
                self.view?.showResults([], hasMore: false)
                self.view?.showError(NSLocalizedString("tour_search_failed", comment: ""))
            }
        }
    }

    private func loadPopular() {
        interactor.popular(type: context.query.type) { [weak self] result in
            guard let self, case .success(let items) = result else { return }
            // The rail is a nice-to-have; a failure here leaves it empty rather
            // than interrupting a search that otherwise worked.
            self.view?.showPopular(self.cards(from: items, showsPrice: false))
        }
    }

    /// The one place domain records become card models, so both the list and the
    /// rail agree on how a tour is presented.
    private func cards(from tours: [TourModel], showsPrice: Bool? = nil) -> [TourCardModel] {
        tours.map {
            TourCardModel(
                tour: $0,
                isFavorite: favorites.contains($0.id),
                showsPrice: showsPrice
            )
        }
    }
}
