//
//  ProfilesInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import RxSwift

final class ProfilesInteractor: ProfilesInteractorProtocol {
    func fetchUser() -> Observable<UserProfile> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(ProfilesError.notAuthenticated)
                return Disposables.create()
            }

            UserService.shared.fetchUserProfile(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        let profile = UserProfile(name: user.name, phone: user.phone, avatarURL: user.avatar)
                        observer.onNext(profile)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
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
                    // Filled in once `fetchCardCount` returns; nil keeps the badge hidden.
                    type: .cards(badge: nil),
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
    
    func fetchCardCount() -> Observable<Int> {
        Observable.create { observer in
            guard let uid = AuthService.shared.getCurrentUserId() else {
                observer.onError(ProfilesError.notAuthenticated)
                return Disposables.create()
            }

            CardService.shared.fetchCards(uid: uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cards):
                        observer.onNext(cards.count)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create()
        }
    }

    func signOut() -> Result<Void, Error> {
        switch AuthService.shared.logout() {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
