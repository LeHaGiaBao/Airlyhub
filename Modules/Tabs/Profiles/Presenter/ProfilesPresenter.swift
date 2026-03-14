//
//  ProfilesPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import RxSwift

final class ProfilesPresenter: ProfilesPresenterProtocol {
    let interactor: ProfilesInteractorProtocol
    let router: ProfilesRouterProtocol
    
    init(interactor: ProfilesInteractorProtocol,
         router: ProfilesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getUserProfile() -> UserProfile {
        return interactor.fetchUser()
    }
    
    func getMenuItems() -> [ProfilesMenuSection] {
        return interactor.fetchMenuItems()
    }
}

extension ProfilesPresenter: ProfilesRouterProtocol {
    func navigateToNotifications() -> Observable<NotificationsBuilderAction> {
        router.navigateToNotifications()
    }
    
    func navigateToMyTickets() -> Observable<MyTicketsBuilderAction> {
        router.navigateToMyTickets()
    }
    
    func navigateToMyCards() -> Observable<MyCardsBuilderAction> {
        router.navigateToMyCards()
    }
    
    func navigateToCustomerService() -> Observable<CustomerServiceBuilderAction> {
        router.navigateToCustomerService()
    }
    
    func navigateToSettings() -> Observable<SettingsBuilderAction> {
        router.navigateToSettings()
    }
    
    func goToLogout() {
        router.goToLogout()
    }
}
