//
//  UIView+ShadowExample.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

final class UIViewShadowExample: UIView {
    private let shadowProvider = ShadowProvider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        applyCompositeShadow(
            shadowProvider.shadow(for: .sm),
            cornerRadius: 12
        )

        updateCompositeShadowPath()
    }
}
