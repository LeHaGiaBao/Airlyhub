//
//  ProfilesInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfilesInteractorProtocol: AnyObject {
    func fetchUser() -> Observable<UserProfile>
    func fetchMenuItems() -> [ProfilesMenuSection]
    /// Total number of saved cards for the current user, for the "My cards" badge.
    func fetchCardCount() -> Observable<Int>
    func signOut() -> Result<Void, Error>
}
