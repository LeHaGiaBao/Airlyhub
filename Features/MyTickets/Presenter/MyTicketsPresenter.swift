//
//  MyTicketsPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class MyTicketsPresenter {
    private var _myTicketsBuilderAction = BehaviorSubject<MyTicketsBuilderAction>(value: .cancel)
    private var hasCompleted = false
    
    var myTicketsBuilderAction: Observable<MyTicketsBuilderAction> {
        _myTicketsBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _myTicketsBuilderAction.onNext(.cancel)
        _myTicketsBuilderAction.onCompleted()
    }
}
