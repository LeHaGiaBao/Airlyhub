//
//  EditProfileBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import RxSwift

enum EditProfileBuilderAction {
    case cancel
    case saved
}

final class EditProfileBuilder {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func build() -> (UIViewController, Observable<EditProfileBuilderAction>) {
        let interactor = EditProfileInteractor(auth: container.authRepository,
                                               users: container.userRepository,
                                               avatars: container.avatarRepository)
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(interactor: interactor, router: router)
        let view = EditProfileView(presenter: presenter)
        presenter.view = view
        router.viewController = view
        return (view, presenter.editProfileBuilderAction)
    }
}
