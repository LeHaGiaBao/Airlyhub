//
//  MyCardsRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class MyCardsRouter: MyCardsRouterProtocol {
    weak var viewController: UIViewController?

    func presentAddCardSheet(onSubmit: @escaping (NewCardInput) -> Void) {
        let sheet = AddCardBottomSheetViewController()
        sheet.onSubmit = onSubmit
        viewController?.present(sheet, animated: false)
    }

    func presentDeleteConfirmation(cardTitle: String, onConfirm: @escaping () -> Void) {
        let sheet = DeleteCardConfirmSheetViewController(cardTitle: cardTitle)
        sheet.onDelete = onConfirm
        viewController?.present(sheet, animated: false)
    }
}
