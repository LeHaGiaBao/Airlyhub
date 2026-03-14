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
        let presenter = CustomerServicePresenter()
        let view = CustomerServiceView(presenter: presenter)
        return (view, presenter.customerServiceBuilderAction)
    }
}
