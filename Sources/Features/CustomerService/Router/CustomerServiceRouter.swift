//
//  CustomerServiceRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import PhotosUI

final class CustomerServiceRouter: CustomerServiceRouterProtocol {
    weak var viewController: UIViewController?

    func presentPhotoPicker(delegate: PHPickerViewControllerDelegate) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = delegate
        viewController?.present(picker, animated: true)
    }
}
