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
        return interactor.fetchMyTickets()
    }
}
