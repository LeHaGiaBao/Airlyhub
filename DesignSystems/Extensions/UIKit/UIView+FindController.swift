//
//  UIView+FindController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 26/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController { return vc }
            responder = r.next
        }
        return nil
    }
}
