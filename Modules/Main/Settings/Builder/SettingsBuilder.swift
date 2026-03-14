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
        let presenter = SettingsPresenter()
        let view = SettingsView(presenter: presenter)
        return (view, presenter.settingsBuilderAction)
    }
}
