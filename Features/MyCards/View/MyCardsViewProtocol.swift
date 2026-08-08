//
//  MyCardsViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol MyCardsViewProtocol: AnyObject {
    func render(_ state: MyCardsViewState)
    func showLoading()
    func hideLoading()
    func showToast(_ message: String, style: ToastStyle)
}
