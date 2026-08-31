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
    static func barcode(from value: String, height: CGFloat = 64) -> UIImage? {
        guard let data = value.data(using: .ascii),
              let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(1, forKey: "inputQuietSpace")

        guard let output = filter.outputImage, output.extent.height > 0 else { return nil }

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
