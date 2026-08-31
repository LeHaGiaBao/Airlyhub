//
//  UIImage+Downscale.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIImage {
    func downscaled(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let longestEdge = max(size.width, size.height)
        guard longestEdge > maxDimension, longestEdge > 0 else { return self }

        let scale = maxDimension / longestEdge
        let targetSize = CGSize(width: (size.width * scale).rounded(),
                                height: (size.height * scale).rounded())

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true

        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
