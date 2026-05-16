//
//  Devices.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 16/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

public enum Devices {
    static let width: CGFloat  = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height
    
    static let paddingHorizontal: CGFloat = 20
    
    static let hasNotch: Bool = {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return false }
        return window.safeAreaInsets.top >= 44
    }()

    static let hasDynamicIsland: Bool = {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return false }
        return window.safeAreaInsets.top >= 59
    }()
    
    static var topBarSafeHeight: CGFloat {
        hasNotch ? 44 : 20
    }
    
    static var statusBarHeight: CGFloat {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else { return hasNotch ? 44 : 20 }
        return window.safeAreaInsets.top
    }

    static var bottomSafeHeight: CGFloat {
        (hasNotch || hasDynamicIsland) ? 34 : 20
    }
    
    static let bottomTabHeightStatic: CGFloat = 58

    static let hitSlop = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}
