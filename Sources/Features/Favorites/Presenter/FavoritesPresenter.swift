//
//  FavoritesPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class FavoritesPresenter: FavoritesPresenterProtocol {
    private weak var view: FavoritesViewProtocol?
    private let interactor: FavoritesInteractorProtocol
    private let router: FavoritesRouterProtocol

    private var tab: FavoritesTab = .tours
    private var items: [TourModel] = []

    init(view: FavoritesViewProtocol,
         interactor: FavoritesInteractorProtocol,
         router: FavoritesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showTabs(titles: FavoritesTab.allCases.map(\.title), selectedIndex: tab.rawValue)
        load()
    }

    func didSelectTab(at index: Int) {
        guard let selected = FavoritesTab(rawValue: index), selected != tab else { return }
        tab = selected
        load()
    }

    func didSelectItem(id: String) {
        router.showTourDetail(id: id)
    }

    func didRemoveFavorite(id: String) {
        interactor.setFavorite(false, tourID: id)
        items.removeAll { $0.id == id }
        render()
    }

    private func load() {
        view?.showLoading(true)

        let requested = tab
        interactor.favorites(ofType: tab.tourType) { [weak self] result in
            guard let self else { return }
            guard self.tab == requested else { return }

            self.view?.showLoading(false)

            switch result {
            case .success(let items):
                self.items = items
                self.render()
            case .failure:
                self.items = []
                self.render()
                self.view?.showError(NSLocalizedString("favorites_load_failed", comment: ""))
            }
        }
    }

    private func render() {
        view?.showItems(
            items.map { TourCardModel(tour: $0, isFavorite: true) },
            emptyMessage: tab.emptyMessage
        )
    }
}
