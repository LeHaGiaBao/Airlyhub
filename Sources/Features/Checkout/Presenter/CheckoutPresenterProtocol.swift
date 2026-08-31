//
//  CheckoutPresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol CheckoutPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didTapPay(with method: CheckoutPaymentMethod)
}
