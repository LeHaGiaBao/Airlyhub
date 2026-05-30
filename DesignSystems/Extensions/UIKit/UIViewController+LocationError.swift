//
//  UIViewController+LocationError.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLocationError(_ error: LocationServiceError) {
        let message: String
        switch error {
        case .denied:
            message = NSLocalizedString("location_permission_denied", comment: "")
        case .failed:
            message = NSLocalizedString("location_fetch_failed", comment: "")
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        present(alert, animated: true)
    }
}
