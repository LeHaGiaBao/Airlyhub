//
//  UILabelExtension.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit
import ObjectiveC

/// Which line height `applyTypography` should give a label.
enum TypographyLineHeight {
    case token
    case natural
    case fixed(CGFloat)
}

extension UILabel {
    private static var typographyKey: UInt8 = 0
    private static var lineHeightKey: UInt8 = 0

    private var appliedTypography: TypographyStyle? {
        get { objc_getAssociatedObject(self, &Self.typographyKey) as? TypographyStyle }
        set { objc_setAssociatedObject(self, &Self.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var appliedLineHeight: TypographyLineHeight {
        get { objc_getAssociatedObject(self, &Self.lineHeightKey) as? TypographyLineHeight ?? .token }
        set { objc_setAssociatedObject(self, &Self.lineHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func applyTypography(_ style: TypographyStyle, lineHeight: TypographyLineHeight = .token) {
        appliedTypography = style
        appliedLineHeight = lineHeight

        let resolvedLineHeight: CGFloat?
        switch lineHeight {
        case .token: resolvedLineHeight = style.lineHeight
        case .natural: resolvedLineHeight = nil
        case .fixed(let value): resolvedLineHeight = value
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.fontSize * style.letterSpacing
        ]

        if let resolvedLineHeight {
            paragraphStyle.minimumLineHeight = resolvedLineHeight
            paragraphStyle.maximumLineHeight = resolvedLineHeight
            attributes[.baselineOffset] = (resolvedLineHeight - style.font.lineHeight) / 4
        }

        attributes[.paragraphStyle] = paragraphStyle
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }

    func setText(_ newText: String?) {
        text = newText
        if let style = appliedTypography {
            applyTypography(style, lineHeight: appliedLineHeight)
        }
    }
}
