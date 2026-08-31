//
//  FeedbackGenerator.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation
import UIKit

public final class FeedbackGenerator {
    static func onFeedbackGenerator(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
