//
//  ProfileEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 06/02/2026.
//

import Foundation

struct UserProfile {
    let name: String
    let phone: String
    let avatarURL: String?
}

enum ProfileMenuItemType {
    case notifications
    case tickets
    case cards(badge: Int?)
    case customerService
    case settings
    case logout
}

struct ProfileMenuItem {
    let title: String
    let iconName: String
    let type: ProfileMenuItemType
}
