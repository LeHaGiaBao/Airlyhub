//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ProfilesBuilder: ProfilesRouterProtocol {
    static func createModule() -> UIViewController {
        let view = ProfilesViewController()
        let interactor = ProfilesInteractor()
        let router = ProfilesBuilder()
        let presenter = ProfilesPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        return view
    }
}
