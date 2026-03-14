//
//  SettingsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import RxSwift

enum SettingsAction {
    case cancel
}

final class SettingsBuilder {
    func build() -> (UIViewController, Observable<SettingsAction>) {
        let presenter = SettingsPresenter()
        let view = SettingsView(presenter: presenter)
        return (view, presenter.settingsAction)
    }
}
