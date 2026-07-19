//
//  ToastStyle.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ToastStyle
enum ToastStyle {
    case success
    case info
    case error

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    var iconColor: UIColor {
        switch self {
        case .success: return AppColor.PrimaryColors.Success.color500 ?? .systemGreen
        case .info: return AppColor.PrimaryColors.Primary.color500 ?? .systemBlue
        case .error: return AppColor.PrimaryColors.Error.color500 ?? .systemRed
        }
    }
}
