//
//  InputStyle.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

public struct InputStyle {
    let borderColor: UIColor?
    let backgroundColor: UIColor?
    let textColor: UIColor?
    let placeholderColor: UIColor?
    let iconColor: UIColor?
    let hintColor: UIColor?
    let hintMessage: String?
    let isUserInteractionEnabled: Bool

    static func style(for state: InputState) -> InputStyle {
        switch state {
        case .defaultInput:
            return InputStyle(borderColor: InputTokens.borderDefault,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.iconDefault,
                              hintColor: nil,
                              hintMessage: nil,
                              isUserInteractionEnabled: true)
        case .focused:
            return InputStyle(borderColor: InputTokens.borderFocused,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.iconActive,
                              hintColor: nil,
                              hintMessage: nil,
                              isUserInteractionEnabled: true)
        case .filled:
            return InputStyle(borderColor: InputTokens.borderDefault,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.iconActive,
                              hintColor: nil,
                              hintMessage: nil,
                              isUserInteractionEnabled: true)
        case .error(let message):
            return InputStyle(borderColor: InputTokens.bgError,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.iconError,
                              hintColor: InputTokens.textError,
                              hintMessage: message,
                              isUserInteractionEnabled: true)
        case .warning(let message):
            return InputStyle(borderColor: InputTokens.borderWarning,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.iconWarning,
                              hintColor: InputTokens.textWarning,
                              hintMessage: message,
                              isUserInteractionEnabled: true)
        case .success:
            return InputStyle(borderColor: InputTokens.borderSuccess,
                              backgroundColor: InputTokens.bgDefault,
                              textColor: InputTokens.textInput,
                              placeholderColor: InputTokens.textPlaceholder,
                              iconColor: InputTokens.textSuccess,
                              hintColor: nil,
                              hintMessage: nil,
                              isUserInteractionEnabled: true)
        case .disabled:
            return InputStyle(borderColor: InputTokens.borderDisabled,
                              backgroundColor: InputTokens.borderDisabled,
                              textColor: InputTokens.textDisabled,
                              placeholderColor: InputTokens.textDisabled,
                              iconColor: InputTokens.textDisabled,
                              hintColor: nil,
                              hintMessage: nil,
                              isUserInteractionEnabled: false)
        }
    }
}
