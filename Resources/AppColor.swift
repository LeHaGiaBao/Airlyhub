//
//  AppColor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

/// Centralized color system for the app
/// Maps all color assets to easy-to-use properties
///
/// NOTE: Asset names are based on the folder structure in Assets.xcassets.
/// If colors don't load, verify the asset names in Xcode:
/// 1. Open Assets.xcassets
/// 2. Select a color asset
/// 3. Check the "Name" field in the Attributes Inspector
/// 4. Update the asset name strings below if they differ
///
/// Usage Examples:
/// - AppColor.PrimaryColors.Primary.color500
struct AppColor {
    
    // MARK: - Primary Colors
    struct PrimaryColors {
        
        // MARK: - Primary Colors
        struct Primary {
            static let color50 = UIColor(named: "PrimaryColor/Primary/50")
            static let color100 = UIColor(named: "PrimaryColor/Primary/100")
            static let color200 = UIColor(named: "PrimaryColor/Primary/200")
            static let color300 = UIColor(named: "PrimaryColor/Primary/300")
            static let color400 = UIColor(named: "PrimaryColor/Primary/400")
            static let color500 = UIColor(named: "PrimaryColor/Primary/500")
            static let color600 = UIColor(named: "PrimaryColor/Primary/600")
            static let color700 = UIColor(named: "PrimaryColor/Primary/700")
            static let color800 = UIColor(named: "PrimaryColor/Primary/800")
            static let color900 = UIColor(named: "PrimaryColor/Primary/900")
        }
        
        // MARK: - Gray Colors
        struct Gray {
            static let color25 = UIColor(named: "PrimaryColor/Gray/25")
            static let color50 = UIColor(named: "PrimaryColor/Gray/50")
            static let color100 = UIColor(named: "PrimaryColor/Gray/100")
            static let color200 = UIColor(named: "PrimaryColor/Gray/200")
            static let color300 = UIColor(named: "PrimaryColor/Gray/300")
            static let color400 = UIColor(named: "PrimaryColor/Gray/400")
            static let color500 = UIColor(named: "PrimaryColor/Gray/500")
            static let color600 = UIColor(named: "PrimaryColor/Gray/600")
            static let color700 = UIColor(named: "PrimaryColor/Gray/700")
            static let color800 = UIColor(named: "PrimaryColor/Gray/800")
            static let color900 = UIColor(named: "PrimaryColor/Gray/900")
        }
        
        // MARK: - Error Colors
        
        struct Error {
            static let color50 = UIColor(named: "PrimaryColor/Error/50")
            static let color100 = UIColor(named: "PrimaryColor/Error/100")
            static let color200 = UIColor(named: "PrimaryColor/Error/200")
            static let color300 = UIColor(named: "PrimaryColor/Error/300")
            static let color400 = UIColor(named: "PrimaryColor/Error/400")
            static let color500 = UIColor(named: "PrimaryColor/Error/500")
            static let color600 = UIColor(named: "PrimaryColor/Error/600")
            static let color700 = UIColor(named: "PrimaryColor/Error/700")
            static let color800 = UIColor(named: "PrimaryColor/Error/800")
            static let color900 = UIColor(named: "PrimaryColor/Error/900")
            
            // Convenience properties
            static let light = color100
            static let main = color500
            static let dark = color700
        }
        
        // MARK: - Success Colors
        struct Success {
            static let color50 = UIColor(named: "PrimaryColor/Success/50")
            static let color100 = UIColor(named: "PrimaryColor/Success/100")
            static let color200 = UIColor(named: "PrimaryColor/Success/200")
            static let color300 = UIColor(named: "PrimaryColor/Success/300")
            static let color400 = UIColor(named: "PrimaryColor/Success/400")
            static let color500 = UIColor(named: "PrimaryColor/Success/500")
            static let color600 = UIColor(named: "PrimaryColor/Success/600")
            static let color700 = UIColor(named: "PrimaryColor/Success/700")
            static let color800 = UIColor(named: "PrimaryColor/Success/800")
            static let color900 = UIColor(named: "PrimaryColor/Success/900")
        }
        
        // MARK: - Warning Colors
        struct Warning {
            static let color50 = UIColor(named: "PrimaryColor/Warning/50")
            static let color100 = UIColor(named: "PrimaryColor/Warning/100")
            static let color200 = UIColor(named: "PrimaryColor/Warning/200")
            static let color300 = UIColor(named: "PrimaryColor/Warning/300")
            static let color400 = UIColor(named: "PrimaryColor/Warning/400")
            static let color500 = UIColor(named: "PrimaryColor/Warning/500")
            static let color600 = UIColor(named: "PrimaryColor/Warning/600")
            static let color700 = UIColor(named: "PrimaryColor/Warning/700")
            static let color800 = UIColor(named: "PrimaryColor/Warning/800")
            static let color900 = UIColor(named: "PrimaryColor/Warning/900")
        }
    }
    
    // MARK: - Secondary Colors
    struct SecondaryColors {
        
        // MARK: Bluelight Colors
        struct Bluelight {
            static let color50 = UIColor(named: "SecondaryColor/Bluelight/50")
            static let color100 = UIColor(named: "SecondaryColor/Bluelight/100")
            static let color200 = UIColor(named: "SecondaryColor/Bluelight/200")
            static let color300 = UIColor(named: "SecondaryColor/Bluelight/300")
            static let color400 = UIColor(named: "SecondaryColor/Bluelight/400")
            static let color500 = UIColor(named: "SecondaryColor/Bluelight/500")
            static let color600 = UIColor(named: "SecondaryColor/Bluelight/600")
            static let color700 = UIColor(named: "SecondaryColor/Bluelight/700")
            static let color800 = UIColor(named: "SecondaryColor/Bluelight/800")
            static let color900 = UIColor(named: "SecondaryColor/Bluelight/900")
        }
        
        // MARK: Mint Colors
        struct Mint {
            static let color50 = UIColor(named: "SecondaryColor/Mint/50")
            static let color100 = UIColor(named: "SecondaryColor/Mint/100")
            static let color200 = UIColor(named: "SecondaryColor/Mint/200")
            static let color300 = UIColor(named: "SecondaryColor/Mint/300")
            static let color400 = UIColor(named: "SecondaryColor/Mint/400")
            static let color500 = UIColor(named: "SecondaryColor/Mint/500")
            static let color600 = UIColor(named: "SecondaryColor/Mint/600")
            static let color700 = UIColor(named: "SecondaryColor/Mint/700")
            static let color800 = UIColor(named: "SecondaryColor/Mint/800")
            static let color900 = UIColor(named: "SecondaryColor/Mint/900")
            
            static let main = color500
        }
        
        // MARK: Pink Colors
        struct Pink {
            static let color50 = UIColor(named: "SecondaryColor/Pink/50")
            static let color100 = UIColor(named: "SecondaryColor/Pink/100")
            static let color200 = UIColor(named: "SecondaryColor/Pink/200")
            static let color300 = UIColor(named: "SecondaryColor/Pink/300")
            static let color400 = UIColor(named: "SecondaryColor/Pink/400")
            static let color500 = UIColor(named: "SecondaryColor/Pink/500")
            static let color600 = UIColor(named: "SecondaryColor/Pink/600")
            static let color700 = UIColor(named: "SecondaryColor/Pink/700")
            static let color800 = UIColor(named: "SecondaryColor/Pink/800")
            static let color900 = UIColor(named: "SecondaryColor/Pink/900")
        }
        
        // MARK: Purple Colors
        struct Purple {
            static let color50 = UIColor(named: "SecondaryColor/Purple/50")
            static let color100 = UIColor(named: "SecondaryColor/Purple/100")
            static let color200 = UIColor(named: "SecondaryColor/Purple/200")
            static let color300 = UIColor(named: "SecondaryColor/Purple/300")
            static let color400 = UIColor(named: "SecondaryColor/Purple/400")
            static let color500 = UIColor(named: "SecondaryColor/Purple/500")
            static let color600 = UIColor(named: "SecondaryColor/Purple/600")
            static let color700 = UIColor(named: "SecondaryColor/Purple/700")
            static let color800 = UIColor(named: "SecondaryColor/Purple/800")
            static let color900 = UIColor(named: "SecondaryColor/Purple/900")
        }
    }
}
