//
//  ProfilesRouterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfilesRouterProtocol: AnyObject {
    func navigateToNotifications() -> Observable<NotificationsBuilderAction>
    func navigateToMyTickets() -> Observable<MyTicketsBuilderAction>
    func navigateToMyCards() -> Observable<MyCardsBuilderAction>
    func navigateToCustomerService() -> Observable<CustomerServiceBuilderAction>
    func navigateToSettings() -> Observable<SettingsBuilderAction>
    func presentLogoutConfirmation(onConfirm: @escaping () -> Void)
    func navigateToAuth()
    func showLogoutError(_ message: String)
    func showAvatarUploadError()
}
