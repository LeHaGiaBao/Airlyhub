//
//  ProfilesViewModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation

protocol ProfilesInteractorProtocol: AnyObject {
    func fetchUser() -> UserProfile
    func fetchMenuItems() -> [ProfilesMenuSection]
}

protocol ProfilesPresenterProtocol: AnyObject, ProfilesRouterProtocol {
    func getUserProfile() -> UserProfile
    func getMenuItems() -> [ProfilesMenuSection]
}

protocol ProfilesRouterProtocol: AnyObject {
    func navigateToNotifications()
    func navigateToMyTickets()
    func navigateToMyCards()
    func navigateToCustomerService()
    func navigateToSettings()
    func goToLogout()
}
