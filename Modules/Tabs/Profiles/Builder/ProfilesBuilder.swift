//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit

final class ProfilesBuilder {
    static func build() -> UIViewController {
        let interactor = ProfilesInteractor()
        let router = ProfilesRouter()
        let presenter = ProfilesPresenter(interactor: interactor,
                                          router: router)
        let view = ProfilesView(presenter: presenter)
        return view
    }
}
