//
//  InterFontWeight.swift
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
        case .bold: return "Inter-Bold"
        case .medium: return "Inter-Medium"
        case .regular: return "Inter-Regular"
        case .semibold: return "Inter-SemiBold"
        }
    }

    var systemWeight: UIFont.Weight {
        switch self {
        case .bold: return .bold
        case .medium: return .medium
        case .regular: return .regular
        case .semibold: return .semibold
        }
    }

    func font(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: systemWeight)
    }
}
