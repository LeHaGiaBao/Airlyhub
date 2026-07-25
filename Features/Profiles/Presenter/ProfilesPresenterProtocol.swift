//
//  ProfilesPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfilesPresenterProtocol: AnyObject, ProfilesRouterProtocol {
    func getUserProfile() -> Observable<UserProfile>
    func getMenuItems() -> [ProfilesMenuSection]
    func updateAvatar(imageData: Data) -> Observable<String>
    func goToLogout()
}
