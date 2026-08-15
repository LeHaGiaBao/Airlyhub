//
//  CustomerServiceBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum CustomerServiceBuilderAction {
    case cancel
}

final class CustomerServiceBuilder {
    func build() -> (UIViewController, Observable<CustomerServiceBuilderAction>) {
        let interactor = CustomerServiceInteractor()
        let router = CustomerServiceRouter()
        let presenter = CustomerServicePresenter(interactor: interactor,
                                                 router: router)
        let view = CustomerServiceView(presenter: presenter, router: router)
        presenter.view = view
        router.viewController = view
        return (view, presenter.customerServiceBuilderAction)
    }
}
