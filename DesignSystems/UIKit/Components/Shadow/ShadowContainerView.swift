//
//  ShadowContainerView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

final class ShadowContainerView: UIView {
    private let contentView = UIView()
    private var shadowLayers: [CALayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        addSubview(contentView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds

        shadowLayers.forEach {
            $0.frame = bounds
            $0.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: contentView.layer.cornerRadius
            ).cgPath
        }
    }

    func applyCompositeShadow(
        _ token: CompositeShadowToken,
        cornerRadius: CGFloat
    ) {
        shadowLayers.forEach { $0.removeFromSuperlayer() }
        shadowLayers.removeAll()

        for shadow in token.shadows {
            let layer = CALayer()
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = shadow.opacity
            layer.shadowOffset = shadow.offset
            layer.shadowRadius = shadow.radius
            layer.masksToBounds = false

            self.layer.insertSublayer(layer, at: 0)
            shadowLayers.append(layer)
        }

        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }

    func setContent(_ view: UIView) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(view)
        view.frame = contentView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
