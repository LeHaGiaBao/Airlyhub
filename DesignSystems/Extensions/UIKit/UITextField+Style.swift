//
//  UITextField+Style.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UITextField {
    func applyStyle(_ state: InputState) {
        let style = InputStyle.style(for: state)
        layer.cornerRadius = InputTokens.cornerRadius
        layer.borderWidth = InputTokens.borderWidth
        layer.borderColor = style.borderColor?.cgColor
        layer.masksToBounds = true
        
        backgroundColor = style.backgroundColor
        textColor = style.textColor
        isUserInteractionEnabled = style.isUserInteractionEnabled
        font = .systemFont(ofSize: InputTokens.fontSize)
 
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: style.placeholderColor as Any]
            )
        }
 
        if leftView == nil {
            let pad = UIView(frame: CGRect(x: 0, y: 0, width: InputTokens.horizontalPadding, height: 1))
            leftView = pad
            leftViewMode = .always
        }
        if rightView == nil {
            let pad = UIView(frame: CGRect(x: 0, y: 0, width: InputTokens.horizontalPadding, height: 1))
            rightView = pad
            rightViewMode = .always
        }
    }
}
