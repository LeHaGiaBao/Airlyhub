//
//  ButtonSize.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

public enum ButtonSize {
    case big
    case middle
    case small

    var height: CGFloat {
        switch self {
        case .big: return 50
        case .middle: return 44
        case .small: return 40
        }
    }
}
