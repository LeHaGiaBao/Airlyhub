//
//  NotificationsEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import UIKit

struct NotificationItem {
    let iconName: UIImage?
    let title: String
    let descscription: String
}

struct NotificationsEntity {
    let date: String
    let notificationItems: [NotificationItem]
}
