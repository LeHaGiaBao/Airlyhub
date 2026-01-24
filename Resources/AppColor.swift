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
            static let color50 = UIColor(named: "blue50")
            static let color100 = UIColor(named: "blue100")
            static let color200 = UIColor(named: "blue200")
            static let color300 = UIColor(named: "blue300")
            static let color400 = UIColor(named: "blue400")
            static let color500 = UIColor(named: "blue500")
            static let color600 = UIColor(named: "blue600")
            static let color700 = UIColor(named: "blue700")
            static let color800 = UIColor(named: "blue800")
            static let color900 = UIColor(named: "blue900")
        }
        
        // MARK: - Gray Colors
        struct Gray {
            static let color25 = UIColor(named: "gray25")
            static let color50 = UIColor(named: "gray50")
            static let color100 = UIColor(named: "gray100")
            static let color200 = UIColor(named: "gray200")
            static let color300 = UIColor(named: "gray300")
            static let color400 = UIColor(named: "gray400")
            static let color500 = UIColor(named: "gray500")
            static let color600 = UIColor(named: "gray600")
            static let color700 = UIColor(named: "gray700")
            static let color800 = UIColor(named: "gray800")
            static let color900 = UIColor(named: "gray900")
        }
        
        // MARK: - Error Colors
        
        struct Error {
            static let color50 = UIColor(named: "error50")
            static let color100 = UIColor(named: "error100")
            static let color200 = UIColor(named: "error200")
            static let color300 = UIColor(named: "error300")
            static let color400 = UIColor(named: "error400")
            static let color500 = UIColor(named: "error500")
            static let color600 = UIColor(named: "error600")
            static let color700 = UIColor(named: "error700")
            static let color800 = UIColor(named: "error800")
            static let color900 = UIColor(named: "error900")
            
            // Convenience properties
            static let light = color100
            static let main = color500
            static let dark = color700
        }
        
        // MARK: - Success Colors
        struct Success {
            static let color50 = UIColor(named: "success50")
            static let color100 = UIColor(named: "success100")
            static let color200 = UIColor(named: "success200")
            static let color300 = UIColor(named: "success300")
            static let color400 = UIColor(named: "success400")
            static let color500 = UIColor(named: "success500")
            static let color600 = UIColor(named: "success600")
            static let color700 = UIColor(named: "success700")
            static let color800 = UIColor(named: "success800")
            static let color900 = UIColor(named: "success900")
        }
        
        // MARK: - Warning Colors
        struct Warning {
            static let color50 = UIColor(named: "warning50")
            static let color100 = UIColor(named: "warning100")
            static let color200 = UIColor(named: "warning200")
            static let color300 = UIColor(named: "warning300")
            static let color400 = UIColor(named: "warning400")
            static let color500 = UIColor(named: "warning500")
            static let color600 = UIColor(named: "warning600")
            static let color700 = UIColor(named: "warning700")
            static let color800 = UIColor(named: "warning800")
            static let color900 = UIColor(named: "warning900")
        }
    }
    
    // MARK: - Secondary Colors
    struct SecondaryColors {
        
        // MARK: Bluelight Colors
        struct Bluelight {
            static let color50 = UIColor(named: "bluelight50")
            static let color100 = UIColor(named: "bluelight100")
            static let color200 = UIColor(named: "bluelight200")
            static let color300 = UIColor(named: "bluelight300")
            static let color400 = UIColor(named: "bluelight400")
            static let color500 = UIColor(named: "bluelight500")
            static let color600 = UIColor(named: "bluelight600")
            static let color700 = UIColor(named: "bluelight700")
            static let color800 = UIColor(named: "bluelight800")
            static let color900 = UIColor(named: "bluelight900")
        }
        
        // MARK: Mint Colors
        struct Mint {
            static let color50 = UIColor(named: "mint50")
            static let color100 = UIColor(named: "mint100")
            static let color200 = UIColor(named: "mint200")
            static let color300 = UIColor(named: "mint300")
            static let color400 = UIColor(named: "mint400")
            static let color500 = UIColor(named: "mint500")
            static let color600 = UIColor(named: "mint600")
            static let color700 = UIColor(named: "mint700")
            static let color800 = UIColor(named: "mint800")
            static let color900 = UIColor(named: "mint900")
            
            static let main = color500
        }
        
        // MARK: Pink Colors
        struct Pink {
            static let color50 = UIColor(named: "pink50")
            static let color100 = UIColor(named: "pink100")
            static let color200 = UIColor(named: "pink200")
            static let color300 = UIColor(named: "pink300")
            static let color400 = UIColor(named: "pink400")
            static let color500 = UIColor(named: "pink500")
            static let color600 = UIColor(named: "pink600")
            static let color700 = UIColor(named: "pink700")
            static let color800 = UIColor(named: "pink800")
            static let color900 = UIColor(named: "pink900")
        }
        
        // MARK: Purple Colors
        struct Purple {
            static let color50 = UIColor(named: "purple50")
            static let color100 = UIColor(named: "purple100")
            static let color200 = UIColor(named: "purple200")
            static let color300 = UIColor(named: "purple300")
            static let color400 = UIColor(named: "purple400")
            static let color500 = UIColor(named: "purple500")
            static let color600 = UIColor(named: "purple600")
            static let color700 = UIColor(named: "purple700")
            static let color800 = UIColor(named: "purple800")
            static let color900 = UIColor(named: "purple900")
        }
    }
    
    // MARK: - Base Colors
    struct BaseColor {
        static let backgroundColor = UIColor(named: "backgroundColor")
    }
}
