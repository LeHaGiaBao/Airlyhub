//
//  MyTicketDetailPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

final class MyTicketDetailPresenter: MyTicketDetailPresenterProtocol {
    private let _myTicketDetailBuilderAction = BehaviorSubject<MyTicketDetailBuilderAction>(value: .cancel)
    private var hasCompleted = false

    private weak var view: MyTicketDetailViewProtocol?
    private let interactor: MyTicketDetailInteractorProtocol
    private let router: MyTicketDetailRouterProtocol
    private let ticket: TicketModel

    init(view: MyTicketDetailViewProtocol,
         interactor: MyTicketDetailInteractorProtocol,
         router: MyTicketDetailRouterProtocol,
         ticket: TicketModel) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.ticket = ticket
    }

    var myTicketDetailBuilderAction: Observable<MyTicketDetailBuilderAction> {
        _myTicketDetailBuilderAction.asObservable()
    }

    func viewDidLoad() {
        view?.showTicket(ticket)
    }

    func didTapBack() {
        dismiss()
    }

    private func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myTicketDetailBuilderAction.onNext(.cancel)
        _myTicketDetailBuilderAction.onCompleted()
    }
}
