//
//  UILabelExtension.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

public enum InterFontWeight {
    case bold
    case medium
    case regular
    case semibold
    
    var fontName: String {
        switch self {
        case .bold: return "Bold"
        case .medium: return "Medium"
        case .regular: return "Regular"
        case .semibold: return "SemiBold"
        }
    }
}

enum TypographyStyle {
    case display2Xl(weight: InterFontWeight)
    case displayXl(weight: InterFontWeight)
    case displayLg(weight: InterFontWeight)
    case displayMd(weight: InterFontWeight)
    case displaySm(weight: InterFontWeight)
    case displayXs(weight: InterFontWeight)
    case textXl(weight: InterFontWeight)
    case textLg(weight: InterFontWeight)
    case textMd(weight: InterFontWeight)
    case textSm(weight: InterFontWeight)
    case textXs(weight: InterFontWeight)
    
    var fontSize: CGFloat {
        switch self {
        case .display2Xl: return 72
        case .displayXl: return 60
        case .displayLg: return 48
        case .displayMd: return 36
        case .displaySm: return 30
        case .displayXs: return 24
        case .textXl: return 20
        case .textLg: return 18
        case .textMd: return 16
        case .textSm: return 14
        case .textXs: return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .display2Xl: return 90
        case .displayXl: return 72
        case .displayLg: return 60
        case .displayMd: return 44
        case .displaySm: return 38
        case .displayXs: return 32
        case .textXl: return 30
        case .textLg: return 28
        case .textMd: return 24
        case .textSm: return 20
        case .textXs: return 18
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .display2Xl, .displayXl, .displayLg, .displayMd: return -0.02 // -2%
        case .displaySm, .displayXs, .textXl, .textLg, .textMd, .textSm, .textXs: return 0 // 0%
        }
    }

    var font: UIFont {
        var weight: InterFontWeight
        switch self {
        case .display2Xl(let w),
                .displayXl(let w),
                .displayLg(let w),
                .displayMd(let w),
                .displaySm(let w),
                .displayXs(let w),
                .textXl(let w),
                .textLg(let w),
                .textMd(let w),
                .textSm(let w),
                .textXs(let w):
            weight = w
        }
        return UIFont(name: weight.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

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
