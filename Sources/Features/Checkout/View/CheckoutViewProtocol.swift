//
//  CheckoutViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol CheckoutViewProtocol: AnyObject {
    func showSavedCards(_ cards: [CardModel])
    func setPaying(_ isPaying: Bool)
    func showError(_ message: String)
}
