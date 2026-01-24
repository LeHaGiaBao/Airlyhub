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

    init(
        view: FlightsViewProtocol,
        interactor: FlightsInteractorProtocol,
        router: FlightsRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showTitle("Flights")
    }
}
