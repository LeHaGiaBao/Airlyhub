//
//  InputTokens.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

public enum InputTokens {
    static let borderDefault     = AppColor.PrimaryColors.Gray.color200
    static let borderFocused     = AppColor.PrimaryColors.Primary.color500
    static let borderError       = AppColor.PrimaryColors.Error.color500
    static let borderWarning     = AppColor.PrimaryColors.Warning.color500
    static let borderSuccess     = AppColor.PrimaryColors.Success.color500
    static let borderDisabled    = AppColor.PrimaryColors.Gray.color100

    static let bgDefault         = AppColor.PrimaryColors.Gray.color25
    static let bgDisabled        = AppColor.PrimaryColors.Gray.color50
    static let bgError           = AppColor.PrimaryColors.Error.color50
    static let bgWarning         = AppColor.PrimaryColors.Warning.color50

    static let textInput         = AppColor.PrimaryColors.Gray.color800
    static let textPlaceholder   = AppColor.PrimaryColors.Gray.color400
    static let textDisabled      = AppColor.PrimaryColors.Gray.color300
    static let textError         = AppColor.PrimaryColors.Error.color600
    static let textWarning       = AppColor.PrimaryColors.Warning.color600
    static let textSuccess       = AppColor.PrimaryColors.Success.color600

    static let iconDefault       = AppColor.PrimaryColors.Gray.color400
    static let iconActive        = AppColor.PrimaryColors.Primary.color500
    static let iconDisabled      = AppColor.PrimaryColors.Gray.color300
    static let iconError         = AppColor.PrimaryColors.Error.color500
    static let iconWarning       = AppColor.PrimaryColors.Warning.color500
    static let iconSuccess       = AppColor.PrimaryColors.Success.color500

    static let height: CGFloat       = 49
    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat  = 1
    static let horizontalPadding: CGFloat = 14
    static let fontSize: CGFloat     = 14
    static let labelFontSize: CGFloat = 14
    static let hintFontSize: CGFloat  = 12
}
