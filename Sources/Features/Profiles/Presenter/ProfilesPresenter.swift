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

    func getUserProfile() -> Observable<UserProfile> {
        return interactor.fetchUser()
    }

    func getMenuItems() -> [ProfilesMenuSection] {
        return interactor.fetchMenuItems()
    }

    func getCardCount() -> Observable<Int> {
        return interactor.fetchCardCount()
    }

    func goToLogout() {
        router.presentLogoutConfirmation { [weak self] in
            self?.performSignOut()
        }
    }

    private func performSignOut() {
        switch interactor.signOut() {
        case .success:
            router.navigateToAuth()
        case .failure(let error):
            router.showLogoutError(error.localizedDescription)
        }
    }
}

extension ProfilesPresenter: ProfilesRouterProtocol {
    func navigateToEditProfile() -> Observable<EditProfileBuilderAction> {
        router.navigateToEditProfile()
    }

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

    func presentLogoutConfirmation(onConfirm: @escaping () -> Void) {
        router.presentLogoutConfirmation(onConfirm: onConfirm)
    }

    func navigateToAuth() {
        router.navigateToAuth()
    }

    func showLogoutError(_ message: String) {
        router.showLogoutError(message)
    }
}
