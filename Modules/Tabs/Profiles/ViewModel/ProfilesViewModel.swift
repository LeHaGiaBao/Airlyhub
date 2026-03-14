//
//  ProfilesViewModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import RxSwift

protocol ProfilesInteractorProtocol: AnyObject {
    func fetchUser() -> UserProfile
    func fetchMenuItems() -> [ProfilesMenuSection]
}

protocol ProfilesPresenterProtocol: AnyObject, ProfilesRouterProtocol {
    func getUserProfile() -> UserProfile
    func getMenuItems() -> [ProfilesMenuSection]
}

protocol ProfilesRouterProtocol: AnyObject {
    func navigateToNotifications() -> Observable<NotificationsAction>
    func navigateToMyTickets() -> Observable<MyTicketsAction>
    func navigateToMyCards() -> Observable<MyCardsAction>
    func navigateToCustomerService() -> Observable<CustomerServiceAction>
    func navigateToSettings() -> Observable<SettingsAction>
    func goToLogout()
}
