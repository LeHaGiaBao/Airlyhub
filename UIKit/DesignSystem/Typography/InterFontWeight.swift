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
        case .bold: return "Bold"
        case .medium: return "Medium"
        case .regular: return "Regular"
        case .semibold: return "SemiBold"
        }
    }
}
