//
//  MyCardsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class MyCardsPresenter {
    private var _myCardsBuilderAction = BehaviorSubject<MyCardsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    
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
