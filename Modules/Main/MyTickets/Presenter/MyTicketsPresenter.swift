//
//  MyTicketsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class MyTicketsPresenter {
    private var _myTicketsAction = BehaviorSubject<MyTicketsAction>(value: .cancel)
    private var hasCompleted = false
    
    var myTicketsAction: Observable<MyTicketsAction> {
        _myTicketsAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myTicketsAction.onNext(.cancel)
        _myTicketsAction.onCompleted()
    }
}
