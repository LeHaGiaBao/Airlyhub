//
//  EditProfileInteractorProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import RxSwift

protocol EditProfileInteractorProtocol: AnyObject {
    func fetchCurrentUser() -> Observable<EditProfileUser>
    func updateProfile(name: String, phone: String, oldPassword: String?, newPassword: String?) -> Observable<Void>
    func updateAvatar(imageData: Data) -> Observable<String>
}
