//
//  TypographyStyle.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

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
        case .display2Xl, .displayXl, .displayLg, .displayMd: return -0.02
        case .displaySm, .displayXs, .textXl, .textLg, .textMd, .textSm, .textXs: return 0
        }
    }

    var font: UIFont {
        var weight: InterFontWeight
        switch self {
        case .display2Xl(let fontWeight),
             .displayXl(let fontWeight),
             .displayLg(let fontWeight),
             .displayMd(let fontWeight),
             .displaySm(let fontWeight),
             .displayXs(let fontWeight),
             .textXl(let fontWeight),
             .textLg(let fontWeight),
             .textMd(let fontWeight),
             .textSm(let fontWeight),
             .textXs(let fontWeight):
            weight = fontWeight
        }
        return weight.font(ofSize: fontSize)
    }
}
