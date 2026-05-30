//
//  LocationFinder+Animation.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension LocationFinder {
    func animateIn() {
        view.layoutIfNeeded()
        sheetBottomConstraint.constant = 0
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5
        ) {
            self.view.layoutIfNeeded()
        }
    }

    func animateOut(completion: @escaping () -> Void) {
        let height = sheetView.bounds.height
        sheetBottomConstraint.constant = height
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            self.dimBackground.alpha = 0
        }, completion: { _ in completion() })
    }
}
