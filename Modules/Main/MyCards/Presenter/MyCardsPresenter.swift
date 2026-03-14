//
//  MyCardsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class MyCardsPresenter {
    private var _myCardsAction = BehaviorSubject<MyCardsAction>(value: .cancel)
    private var hasCompleted = false
    
    var myCardsAction: Observable<MyCardsAction> {
        _myCardsAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myCardsAction.onNext(.cancel)
        _myCardsAction.onCompleted()
    }
}
