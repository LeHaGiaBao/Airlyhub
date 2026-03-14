//
//  CustomerServicePresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import RxSwift

final class CustomerServicePresenter {
    private var _customerServiceAction = BehaviorSubject<CustomerServiceAction>(value: .cancel)
    private var hasCompleted = false
    
    var customerServiceAction: Observable<CustomerServiceAction> {
        _customerServiceAction.asObservable()
    }
    
    func dismiss() {
        guard !hasCompleted else { return }
        hasCompleted = true
        _customerServiceAction.onNext(.cancel)
        _customerServiceAction.onCompleted()
    }
}
