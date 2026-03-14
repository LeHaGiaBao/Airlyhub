//
//  CustomerServicePresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class CustomerServicePresenter {
    private var _customerServiceBuilderAction = BehaviorSubject<CustomerServiceBuilderAction>(value: .cancel)
    private var hasCompleted = false
    
    var customerServiceBuilderAction: Observable<CustomerServiceBuilderAction> {
        _customerServiceBuilderAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _customerServiceBuilderAction.onNext(.cancel)
        _customerServiceBuilderAction.onCompleted()
    }
}
