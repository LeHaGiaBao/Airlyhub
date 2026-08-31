//
//  CheckoutEntity.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// What the user picked to pay with — either a freshly typed card, with a flag
/// for whether it should be saved for next time, or one already on file.
enum CheckoutPaymentMethod {
    case newCard(NewCardInput, save: Bool)
    case savedCard(CardModel)
}
