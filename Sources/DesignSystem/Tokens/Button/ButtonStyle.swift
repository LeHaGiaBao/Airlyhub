//
//  ButtonStyle.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

public enum ButtonStyle {
    case defaultButton(size: ButtonSize)
    case roundedButton(size: ButtonSize)
    case outlinedButton(size: ButtonSize)
    case outlinedRoundedButton(size: ButtonSize)

    var radius: CGFloat {
        switch self {
        case .defaultButton(let size), .outlinedButton(let size):
            return 8
        case .roundedButton(let size), .outlinedRoundedButton(let size):
            return size.height / 2
        }
    }
}
