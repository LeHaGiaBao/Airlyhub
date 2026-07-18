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

    init(view: FavoritesViewProtocol,
         interactor: FavoritesInteractorProtocol,
         router: FavoritesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {}
}
