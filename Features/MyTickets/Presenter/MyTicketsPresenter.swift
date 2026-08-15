//
//  MyTicketsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import RxSwift

final class MyTicketsPresenter: MyTicketsPresenterProtocol {
    private var _myTicketsBuilderAction = BehaviorSubject<MyTicketsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private let interactor: MyTicketsInteractorProtocol
    private let router: MyTicketsRouterProtocol

    /// Fetched once. The table asks for the sections on every cell, header and tap,
    /// and a tap has to resolve to the same record the row was built from — which a
    /// re-fetch on each call cannot promise once the source is anything but a
    /// constant.
    private lazy var sections: [MyTicketsSection] = interactor.fetchMyTickets()

    init(interactor: MyTicketsInteractorProtocol,
         router: MyTicketsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var myTicketsBuilderAction: Observable<MyTicketsBuilderAction> {
        _myTicketsBuilderAction.asObservable()
    }

    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myTicketsBuilderAction.onNext(.cancel)
        _myTicketsBuilderAction.onCompleted()
    }

    func getMyTickets() -> [MyTicketsSection] {
        return sections
    }

    func navigateToTicketDetail(at indexPath: IndexPath) -> Observable<MyTicketDetailBuilderAction> {
        guard let ticket = ticket(at: indexPath) else { return .empty() }
        return router.navigateToTicketDetail(ticket: ticket)
    }

    private func ticket(at indexPath: IndexPath) -> TicketModel? {
        guard sections.indices.contains(indexPath.section) else { return nil }

        let tickets = sections[indexPath.section].tickets
        guard tickets.indices.contains(indexPath.row) else { return nil }

        return tickets[indexPath.row]
    }
}
