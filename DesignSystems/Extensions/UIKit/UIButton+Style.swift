//
//  UIButton+Style.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

public extension UIButton {

    func applyButtonStyle(_ style: ButtonStyle) {
        var config: UIButton.Configuration

        switch style {
        case .defaultButton, .roundedButton:
            config = .filled()
        case .outlinedButton, .outlinedRoundedButton:
            config = .bordered()
        }

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = .systemFont(ofSize: 15, weight: .semibold)
            return updated
        }

        config.cornerStyle = .fixed
        config.background.cornerRadius = style.radius
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        self.configuration = config

        translatesAutoresizingMaskIntoConstraints = false
        constraints
            .filter { $0.firstAttribute == .height && $0.secondItem == nil }
            .forEach { removeConstraint($0) }
        heightAnchor.constraint(equalToConstant: style.size.height).isActive = true

        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var updated = button.configuration ?? config

            switch style {
            case .defaultButton, .roundedButton:
                switch button.state {
                case .highlighted:
                    updated.background.backgroundColor = AppColor.PrimaryColors.Primary.color700
                        updated.baseForegroundColor = AppColor.PrimaryColors.Gray.color25
                case .disabled:
                    updated.background.backgroundColor = AppColor.PrimaryColors.Primary.color100
                    updated.baseForegroundColor = AppColor.PrimaryColors.Primary.color400
                default:
                    updated.background.backgroundColor = AppColor.PrimaryColors.Primary.color500
                    updated.baseForegroundColor = AppColor.PrimaryColors.Gray.color25
                }

            case .outlinedButton, .outlinedRoundedButton:
                switch button.state {
                case .highlighted:
                    updated.background.backgroundColor = .white
                    updated.background.strokeColor = AppColor.PrimaryColors.Primary.color700
                    updated.background.strokeWidth = 1
                    updated.baseForegroundColor = AppColor.PrimaryColors.Primary.color700
                case .disabled:
                    updated.background.backgroundColor = .white
                    updated.background.strokeColor = AppColor.PrimaryColors.Primary.color200
                    updated.background.strokeWidth = 1
                    updated.baseForegroundColor = AppColor.PrimaryColors.Primary.color200
                default:
                    updated.background.backgroundColor = .white
                    updated.background.strokeColor = AppColor.PrimaryColors.Primary.color500
                    updated.background.strokeWidth = 1
                    updated.baseForegroundColor = AppColor.PrimaryColors.Primary.color500
                }
            }

            self.configuration = updated
        }
    }
}

private extension ButtonStyle {
    var size: ButtonSize {
        switch self {
        case .defaultButton(let s), .roundedButton(let s),
             .outlinedButton(let s), .outlinedRoundedButton(let s):
            return s
        }
    }

    var isOutlined: Bool {
        switch self {
        case .outlinedButton, .outlinedRoundedButton: return true
        default: return false
        }
    }
}
