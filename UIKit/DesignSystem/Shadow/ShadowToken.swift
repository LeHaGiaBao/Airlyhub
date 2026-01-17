//
//  ShadowToken.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

public struct ShadowToken {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
}

public struct CompositeShadowToken {
    let shadows: [ShadowToken]
}
