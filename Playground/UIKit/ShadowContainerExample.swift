//
//  ShadowContainerExample.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

final class ShadowContainerExample: UIView {
    let shadowProvider = ShadowProvider()
    let card = ShadowContainerView()
    let content = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        content.backgroundColor = .white
        backgroundColor = .white
        layer.cornerRadius = 12
        
        card.applyCompositeShadow(
            shadowProvider.shadow(for: .md),
            cornerRadius: 16
        )
        card.setContent(content)
    }
}
