//
//  SettingsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum SettingsBuilderAction {
    case cancel
}

final class SettingsBuilder {
    func build() -> (UIViewController, Observable<SettingsBuilderAction>) {
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(interactor: interactor,
                                          router: router)
        let view = SettingsView(presenter: presenter)
        router.viewController = view
        return (view, presenter.settingsBuilderAction)
    }
}
