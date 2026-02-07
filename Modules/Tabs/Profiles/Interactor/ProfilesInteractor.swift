//
//  ProfilesInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ProfilesInteractor: ProfilesInteractorProtocol {
    func fetchUser() -> UserProfile {
        return UserProfile(name: "David J", phone: "+1 555 555 55 55", avatarURL: nil)
    }
    
    func fetchMenuItems() -> [ProfilesMenuSection] {
        return [
            ProfilesMenuSection(items: [
                ProfilesMenuItem(
                    title: NSLocalizedString("notifications", comment: ""),
                    iconName: AssetsIcon.notifications,
                    type: .notifications,
                    position: .single
                )
            ]),

            ProfilesMenuSection(items: [
                ProfilesMenuItem(
                    title: NSLocalizedString("my_tickets", comment: ""),
                    iconName: AssetsIcon.tickets,
                    type: .tickets,
                    position: .top
                ),
                ProfilesMenuItem(
                    title: NSLocalizedString("my_cards", comment: ""),
                    iconName: AssetsIcon.cards,
                    type: .cards(badge: 1),
                    position: .bottom
                )
            ]),

            ProfilesMenuSection(items: [
                ProfilesMenuItem(
                    title: NSLocalizedString("customer_service", comment: ""),
                    iconName: AssetsIcon.services,
                    type: .customerService,
                    position: .top
                ),
                ProfilesMenuItem(
                    title: NSLocalizedString("settings", comment: ""),
                    iconName: AssetsIcon.setting,
                    type: .settings,
                    position: .bottom
                )
            ]),

            ProfilesMenuSection(items: [
                ProfilesMenuItem(
                    title: NSLocalizedString("logout", comment: ""),
                    iconName: AssetsIcon.logout,
                    type: .logout,
                    position: .single
                )
            ])
        ]
    }

}
