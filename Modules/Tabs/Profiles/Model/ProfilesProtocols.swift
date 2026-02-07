//
//  ProfilesProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

protocol ProfilesViewProtocol: AnyObject {
    func displayUser(_ user: UserProfile)
    func displayMenu(_ items: [ProfilesMenuSection])
}

protocol ProfilesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectMenuItem(_ item: ProfilesMenuItem)
}

protocol ProfilesInteractorProtocol: AnyObject {
    func fetchUser() -> UserProfile
    func fetchMenuItems() -> [ProfilesMenuSection]
}

protocol ProfilesRouterProtocol: AnyObject {
    func navigate(to item: ProfilesMenuItemType)
}
