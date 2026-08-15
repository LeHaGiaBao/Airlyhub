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
    /// Records currently on screen, kept so a removal can re-render without asking
    /// the store again — and so the presenter, not the view, owns the list.
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
        // The card leaves the list rather than staying with a hollow heart: this
        // screen *is* the saved set, so an unsaved card on it would be a card that
        // no longer belongs. Re-hearting happens back in search.
        items.removeAll { $0.id == id }
        render()
    }

    // MARK: - Loading

    private func load() {
        view?.showLoading(true)

        let requested = tab
        interactor.favorites(ofType: tab.tourType) { [weak self] result in
            guard let self else { return }
            // Two taps in quick succession leave both requests in flight; without
            // this the slower one would repaint the list with the other tab's saves.
            guard self.tab == requested else { return }

            self.view?.showLoading(false)

            switch result {
            case .success(let items):
                self.items = items
                self.render()
            case .failure:
                // Empty list plus a toast, so a failure reads as "we couldn't load"
                // rather than as "you have saved nothing".
                self.items = []
                self.render()
                self.view?.showError(NSLocalizedString("favorites_load_failed", comment: ""))
            }
        }
    }

    /// Everything on this screen is saved by definition, hence `isFavorite: true`.
    /// The price row follows the record's type — hidden for tours, shown for
    /// flights — which is `TourCardModel`'s default and matches the design.
    private func render() {
        view?.showItems(
            items.map { TourCardModel(tour: $0, isFavorite: true) },
            emptyMessage: tab.emptyMessage
        )
    }
}
