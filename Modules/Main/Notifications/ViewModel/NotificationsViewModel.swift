//
//  NotificationsViewModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import Foundation
import RxSwift

protocol NotificationsInteractorProtocol: AnyObject {
    func fetchNotifications() -> [NotificationsEntity]
}

protocol NotificationsPresenterProtocol: AnyObject {
    func getNotifications() -> [NotificationsEntity]
}
