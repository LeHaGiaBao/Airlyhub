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

    func viewDidLoad() {}
}
