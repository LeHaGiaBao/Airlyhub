//
//  ProfilesProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import RxSwift

protocol ProfilesInteractorProtocol: AnyObject {
    func fetchUser() -> UserProfile
    func fetchMenuItems() -> [ProfilesMenuSection]
    func signOut() -> Result<Void, Error>
}

protocol ProfilesPresenterProtocol: AnyObject, ProfilesRouterProtocol {
    func getUserProfile() -> UserProfile
    func getMenuItems() -> [ProfilesMenuSection]
    func goToLogout()
}

protocol ProfilesRouterProtocol: AnyObject {
    func navigateToNotifications() -> Observable<NotificationsBuilderAction>
    func navigateToMyTickets() -> Observable<MyTicketsBuilderAction>
    func navigateToMyCards() -> Observable<MyCardsBuilderAction>
    func navigateToCustomerService() -> Observable<CustomerServiceBuilderAction>
    func navigateToSettings() -> Observable<SettingsBuilderAction>
    func presentLogoutConfirmation(onConfirm: @escaping () -> Void)
    func navigateToAuth()
    func showLogoutError(_ message: String)
}
