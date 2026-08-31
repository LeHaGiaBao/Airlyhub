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
    private var context: SearchResultsContext

    private var cursor: TourCursor?
    private var isLoadingMore = false
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
                self.view?.showError(NSLocalizedString("tour_search_failed", comment: ""))
            }
        }
    }

    func didTapFilter() {
        router.presentSearchFilter(criteria: context.criteria) { [weak self] criteria in
            guard let self else { return }
            self.context.criteria = criteria
            self.view?.updateSummary(self.context.summary)
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
                self.view?.showResults([], hasMore: false)
                self.view?.showError(NSLocalizedString("tour_search_failed", comment: ""))
            }
        }
    }

    private func loadPopular() {
        interactor.popular(type: context.query.type) { [weak self] result in
            guard let self, case .success(let items) = result else { return }
            self.view?.showPopular(self.cards(from: items, showsPrice: false))
        }
    }

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
