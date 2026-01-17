//
//  UILabelExtension.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

extension UILabel {
    func applyTypography(_ style: TypographyStyle) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight
        paragraphStyle.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.fontSize * style.letterSpacing,
            .paragraphStyle: paragraphStyle
        ]
        
        let textValue = text ?? ""
        attributedText = NSAttributedString(string: textValue, attributes: attributes)
    }
}
