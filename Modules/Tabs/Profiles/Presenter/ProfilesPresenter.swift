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
    func navigateToNotifications() -> Observable<NotificationsAction> {
        router.navigateToNotifications()
    }
    
    func navigateToMyTickets() -> Observable<MyTicketsAction> {
        router.navigateToMyTickets()
    }
    
    func navigateToMyCards() -> Observable<MyCardsAction> {
        router.navigateToMyCards()
    }
    
    func navigateToCustomerService() -> Observable<CustomerServiceAction> {
        router.navigateToCustomerService()
    }
    
    func navigateToSettings() {
        router.navigateToSettings()
    }
    
    func goToLogout() {
        router.goToLogout()
    }
}
