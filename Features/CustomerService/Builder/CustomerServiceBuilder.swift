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
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> (UIViewController, Observable<CustomerServiceBuilderAction>) {
        let attachments = container.chatAttachmentRepository
        let interactor = CustomerServiceInteractor(chat: container.chatRepository,
                                                   attachments: attachments,
                                                   auth: container.authRepository)
        let router = CustomerServiceRouter()
        let presenter = CustomerServicePresenter(interactor: interactor,
                                                 router: router)
        let view = CustomerServiceView(
            presenter: presenter,
            router: router,
            loadAttachment: { path, completion in attachments.load(path: path, completion: completion) }
        )
        presenter.view = view
        router.viewController = view
        return (view, presenter.customerServiceBuilderAction)
    }
}
