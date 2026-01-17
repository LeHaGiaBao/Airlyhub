//
//  ShadowProvider.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

private let shadowColor = UIColor(red: 16/255, green: 24/255, blue: 40/255, alpha: 1)

public protocol ShadowProviderProtocol {
    func shadow(for level: ShadowLevel) -> CompositeShadowToken
}

public final class ShadowProvider: ShadowProviderProtocol {
    public init() {}
    
    public func shadow(for level: ShadowLevel) -> CompositeShadowToken {
        switch level {
        case .xs:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.05, offset: CGSize(width: 0, height: 1), radius: 2)
            ])
        case .sm:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.1, offset: CGSize(width: 0, height: 1), radius: 3),
                ShadowToken(color: shadowColor, opacity: 0.06, offset: CGSize(width: 0, height: 1), radius: 2)
            ])
        case .md:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.1, offset: CGSize(width: 0, height: 4), radius: 8),
                ShadowToken(color: shadowColor, opacity: 0.05, offset: CGSize(width: 0, height: 4), radius: 6)
            ])
        case .lg:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.1, offset: CGSize(width: 0, height: 12), radius: 16),
                ShadowToken(color: shadowColor, opacity: 0.05, offset: CGSize(width: 0, height: 2), radius: 4)
            ])
        case .xl:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.15, offset: CGSize(width: 0, height: 5), radius: 24),
                ShadowToken(color: shadowColor, opacity: 0.2, offset: CGSize(width: 0, height: 15), radius: 10)
            ])
        case .xxl:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.25, offset: CGSize(width: 0, height: 24), radius: 48)
            ])
        case .xxxl:
            return CompositeShadowToken(shadows: [
                ShadowToken(color: shadowColor, opacity: 0.2, offset: CGSize(width: 0, height: 32), radius: 64)
            ])
        }
    }
}
