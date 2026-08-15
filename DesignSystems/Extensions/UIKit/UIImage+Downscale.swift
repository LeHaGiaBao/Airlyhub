//
//  UIImage+Downscale.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIImage {
    /// Shrinks the image so its longest edge is at most `maxDimension`, preserving the
    /// aspect ratio. Images already smaller are returned untouched rather than upscaled.
    ///
    /// Used before uploading: a full-resolution camera photo is several megabytes, and
    /// nothing in the app displays one larger than a screen's width.
    func downscaled(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let longestEdge = max(size.width, size.height)
        guard longestEdge > maxDimension, longestEdge > 0 else { return self }

        let scale = maxDimension / longestEdge
        let targetSize = CGSize(width: (size.width * scale).rounded(),
                                height: (size.height * scale).rounded())

        let format = UIGraphicsImageRendererFormat.default()
        // Render at 1x: the pixel dimensions are the point of the resize, and letting it
        // pick the screen scale would make the result 2–3× bigger than asked for.
        format.scale = 1
        format.opaque = true

        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
