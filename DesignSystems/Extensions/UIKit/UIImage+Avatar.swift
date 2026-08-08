//
//  UIImage+Avatar.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 09/08/2026.
//

import UIKit

extension UIImage {
    /// Normalizes any source format (HEIC, PNG, JPEG…) into a JPEG small enough to fit
    /// the Realtime Database node limit after base64 encoding, which inflates the payload
    /// by ~33%. `maxBytes` is deliberately well under `AvatarService.maxEncodedLength`.
    /// JPEG is the storage format on purpose: PNG of the same photo runs several times
    /// larger and would blow past the cap.
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

    /// Downscales to fit `maxDimension` and drops the alpha channel. Always redraws, even
    /// when no downscaling is needed, so transparency is composited onto white — JPEG has
    /// no alpha and would otherwise encode transparent pixels as black.
    private func flattened(maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        let ratio = min(1, maxDimension / longestSide)
        let target = CGSize(width: size.width * ratio, height: size.height * ratio)

        // Scale 1 so the output is `target` in pixels, not `target × screen scale`.
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
