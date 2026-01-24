//
//  ProfilesPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ProfilesPresenter: ProfilesPresenterProtocol {
    private weak var view: ProfilesViewProtocol?
    private let interactor: ProfilesInteractorProtocol
    private let router: ProfilesRouterProtocol

    init(
        view: ProfilesViewProtocol,
        interactor: ProfilesInteractorProtocol,
        router: ProfilesRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showTitle("Profiles")
    }
}
