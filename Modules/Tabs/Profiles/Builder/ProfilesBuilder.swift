//
//  ProfilesBuilder.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ProfilesBuilder: ProfilesRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let vc = ProfilesViewController()
        let interactor = ProfilesInteractor()
        let builder = ProfilesBuilder()
        let presenter = ProfilesPresenter(view: vc,
                                          interactor: interactor,
                                          router: builder)
        vc.presenter = presenter
        builder.viewController = vc
        return vc
    }
    
    func navigate(to item: ProfilesMenuItemType) {
        switch item {
        case .logout:
            print("Handle logout")
        default:
            print("Navigate to \(item)")
        }
    }
}
