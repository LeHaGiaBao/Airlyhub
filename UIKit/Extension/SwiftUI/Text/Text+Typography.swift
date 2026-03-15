//
//  Text+Typography.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/03/2026.
//

import SwiftUI

extension Text {
    func applyTypography(_ style: TypographyStyle) -> some View {
        self
            .font(.system(size: style.fontSize))
            .tracking(style.fontSize * style.letterSpacing)
            .lineSpacing(style.lineHeight - style.font.lineHeight)
    }
}
