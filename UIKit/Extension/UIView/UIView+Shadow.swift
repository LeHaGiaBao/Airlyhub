//
//  UIView+Shadow.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit
import ObjectiveC

private var compositeShadowLayersKey: UInt8 = 0

extension UIView {
    private var compositeShadowLayers: [CALayer] {
        get {
            objc_getAssociatedObject(self, &compositeShadowLayersKey) as? [CALayer] ?? []
        }
        set {
            objc_setAssociatedObject(
                self,
                &compositeShadowLayersKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func applyCompositeShadow(_ token: CompositeShadowToken, cornerRadius: CGFloat?) {
        let radius = cornerRadius ?? 0
        compositeShadowLayers.forEach { $0.removeFromSuperlayer() }
        compositeShadowLayers.removeAll()
        
        for shadow in token.shadows {
            let shadowLayer = CALayer()
            shadowLayer.frame = bounds
            shadowLayer.shadowColor = shadow.color.cgColor
            shadowLayer.shadowOpacity = shadow.opacity
            shadowLayer.shadowOffset = shadow.offset
            shadowLayer.shadowRadius = shadow.radius
            shadowLayer.masksToBounds = false

            shadowLayer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: radius
            ).cgPath

            layer.insertSublayer(shadowLayer, at: 0)
            compositeShadowLayers.append(shadowLayer)
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func updateCompositeShadowPath() {
        compositeShadowLayers.forEach {
            $0.frame = bounds
            $0.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius
            ).cgPath
        }
    }
}
