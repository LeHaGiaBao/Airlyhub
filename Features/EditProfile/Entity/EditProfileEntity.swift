//
//  EditProfileEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

struct EditProfileUser {
    let email: String
    let name: String
    let phone: String
    let avatarURL: String?
}

enum EditProfileError: Error, Equatable {
    case notAuthenticated
    case wrongOldPassword
}
