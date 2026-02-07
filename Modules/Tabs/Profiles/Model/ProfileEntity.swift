//
//  ProfileEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 06/02/2026.
//

import Foundation
import UIKit

struct UserProfile {
    let name: String
    let phone: String
    let avatarURL: String?
}

enum ProfilesMenuItemType {
    case notifications
    case tickets
    case cards(badge: Int?)
    case customerService
    case settings
    case logout
}

enum ProfilesMenuCellPosition {
    case single
    case top
    case middle
    case bottom
}

struct ProfilesMenuItem {
    let title: String
    let iconName: UIImage?
    let type: ProfilesMenuItemType
    let position: ProfilesMenuCellPosition
}

struct ProfilesMenuSection {
    let items: [ProfilesMenuItem]
}
