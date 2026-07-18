//
//  MyCardsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class MyCardsPresenter: MyCardsPresenterProtocol {
    private var _myCardsBuilderAction = BehaviorSubject<MyCardsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    private let interactor: MyCardsInteractorProtocol
    private let router: MyCardsRouterProtocol

    init(interactor: MyCardsInteractorProtocol,
         router: MyCardsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    var myCardsBuilderAction: Observable<MyCardsBuilderAction> {
        _myCardsBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myCardsBuilderAction.onNext(.cancel)
        _myCardsBuilderAction.onCompleted()
    }
}
