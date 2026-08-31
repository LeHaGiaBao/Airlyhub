//
//  UIImage+Avatar.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 09/08/2026.
//

import UIKit

extension UIImage {
    func avatarJPEGData(maxDimension: CGFloat = 512, maxBytes: Int = 400_000) -> Data? {
        let normalized = flattened(maxDimension: maxDimension)

        var quality: CGFloat = 0.8
        var data = normalized.jpegData(compressionQuality: quality)

        while let current = data, current.count > maxBytes, quality > 0.1 {
            quality -= 0.1
            data = normalized.jpegData(compressionQuality: quality)
        }

        return data
    }

    private func flattened(maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        let ratio = min(1, maxDimension / longestSide)
        let target = CGSize(width: size.width * ratio, height: size.height * ratio)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true

        return UIGraphicsImageRenderer(size: target, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: target))
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
}
