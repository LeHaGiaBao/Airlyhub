//
//  NotificationsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation

final class NotificationsInteractor: NotificationsInteractorProtocol {
    func fetchNotifications() -> [NotificationsEntity] {
        return [
            NotificationsEntity(date: "Today",
                                notificationItems: [
                                    NotificationItem(iconName: AssetsIcon.notiFlight,
                                                     title: "Air tour has been processed",
                                                     descscription: "Airfield: Bychye Polye, July 30th")
                                ]),
            NotificationsEntity(date: "November 16, 2021",
                                notificationItems: [
                                    NotificationItem(iconName: AssetsIcon.notiRefund,
                                                     title: "Refund issued",
                                                     descscription: "Airfield: Bychye Polye, November 16"),
                                    NotificationItem(iconName: AssetsIcon.notiCancel,
                                                     title: "Flight for November 16 canceled",
                                                     descscription: "Inclement weather")
                                ]),
            NotificationsEntity(date: "November 14, 2021",
                                notificationItems: [
                                    NotificationItem(iconName: AssetsIcon.notiFlight,
                                                     title: "Air tour has been processed",
                                                     descscription: "Airfield: Bychye Polye, November 16"),
                                    NotificationItem(iconName: AssetsIcon.notiWelcome,
                                                     title: "Welcome to Flights 🛩",
                                                     descscription: "Enjoy your flights and have a great experience!")
                                ])
        ]
    }
}
