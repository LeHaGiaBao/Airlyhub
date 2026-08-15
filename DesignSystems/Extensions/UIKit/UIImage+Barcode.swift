//
//  UIImage+Barcode.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    /// Code 128 barcode for `value`, rendered at `height` points.
    ///
    /// Generated rather than shipped as an asset: the bars encode the booking
    /// reference, so a bundled image would be a picture of one particular ticket.
    /// Code 128 is the format for this kind of short alphanumeric reference — it
    /// takes the hyphen in "673-843" as-is, where the EAN and UPC generators only
    /// accept fixed-length digits.
    ///
    /// - Returns: nil when the value is not encodable, which the caller shows as an
    ///   empty strip rather than substituting some other ticket's bars.
    static func barcode(from value: String, height: CGFloat = 64) -> UIImage? {
        // Code 128 is an ASCII format; anything outside it cannot be encoded and is
        // rejected here rather than silently mangled by a lossy conversion.
        guard let data = value.data(using: .ascii),
              let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        // The generator pads with a wide quiet zone by default; the card draws its
        // own padding, so this trims it to the format's minimum.
        filter.setValue(1, forKey: "inputQuietSpace")

        guard let output = filter.outputImage, output.extent.height > 0 else { return nil }

        // Rendered at the final size instead of letting the image view scale a
        // 32pt-tall bitmap up: bars are hairlines, and interpolated edges are what
        // makes a barcode fail to scan.
        let scale = UIScreen.main.scale
        let transform = CGAffineTransform(
            scaleX: scale,
            y: height * scale / output.extent.height
        )
        let scaled = output.transformed(by: transform)

        guard let cgImage = CIContext().createCGImage(scaled, from: scaled.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
