//
//  ProfilesRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit
import RxSwift

final class ProfilesRouter: ProfilesRouterProtocol {
    private let nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func navigateToNotifications() -> Observable<NotificationsAction> {
        let builder = NotificationsBuilder()
        let (view, signal) = builder.build()
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
        return signal.do(onCompleted: { [weak self] in
            self?.nav.popViewController(animated: true)
        })
    }
    
    func navigateToMyTickets() -> Observable<MyTicketsAction> {
        let builder = MyTicketsBuilder()
        let (view, signal) = builder.build()
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
        return signal.do(onCompleted: { [weak self] in
            self?.nav.popViewController(animated: true)
        })
    }
    
    func navigateToMyCards() -> Observable<MyCardsAction> {
        let builder = MyCardsBuilder()
        let (view, signal) = builder.build()
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
        return signal.do(onCompleted: { [weak self] in
            self?.nav.popViewController(animated: true)
        })
    }
    
    func navigateToCustomerService() -> Observable<CustomerServiceAction> {
        let builder = CustomerServiceBuilder()
        let (view, signal) = builder.build()
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
        return signal.do(onCompleted: { [weak self] in
            self?.nav.popViewController(animated: true)
        })
    }
    
    func navigateToSettings() -> Observable<SettingsAction> {
        let builder = SettingsBuilder()
        let (view, signal) = builder.build()
        view.hidesBottomBarWhenPushed = true
        nav.pushViewController(view, animated: true)
        return signal.do(onCompleted: { [weak self] in
            self?.nav.popViewController(animated: true)
        })
    }
    
    func goToLogout() {
        print("goToLogout")
    }
}
