//
//  MyCardsRouterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol MyCardsRouterProtocol: AnyObject {
    func presentAddCardSheet(onSubmit: @escaping (NewCardInput) -> Void)
    func presentDeleteConfirmation(cardTitle: String, onConfirm: @escaping () -> Void)
}
