//
//  FlightsBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FlightsBuilder: FlightsRouterProtocol {
    static func createModule(nav: UINavigationController) -> UIViewController {
        let view = FlightsViewController()
        let interactor = FlightsInteractor()
        let router = FlightsBuilder()
        let presenter = FlightsPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        return view
    }
}
