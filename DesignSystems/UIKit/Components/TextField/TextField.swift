//
//  TextField.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation
import UIKit

final class TextField: UIView {
    private let labelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: InputTokens.labelFontSize, weight: .medium)
        label.textColor = InputTokens.textInput
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = InputTokens.cornerRadius
        view.layer.borderWidth = InputTokens.borderWidth
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    private(set) var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: InputTokens.fontSize)
        textField.textColor = InputTokens.textInput
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
 
    private let leadingIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
 
    private let trailingIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
 
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: InputTokens.hintFontSize)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    var label: String? {
        didSet {
            labelView.text = label
            labelView.isHidden = (label == nil || label?.isEmpty == true)
        }
    }
 
    var placeholder: String? {
        didSet { updatePlaceholder() }
    }
 
    /// Callback when leading icon is tapped
    var onLeadingIconTapped: (() -> Void)?
    
    /// Callback when trailing icon is tapped
    var onTrailingIconTapped: (() -> Void)?
 
    private var currentState: InputState = .defaultInput
 
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupDelegates()
        applyState(.defaultInput)
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupDelegates()
        applyState(.defaultInput)
    }
 
    // MARK: Setup
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
 
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
 
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(hintLabel)
 
        // Inner horizontal stack: [leadingIcon | textField | trailingIcon]
        let innerStack = UIStackView(arrangedSubviews: [leadingIconView, textField, trailingIconView])
        innerStack.axis = .horizontal
        innerStack.spacing = 8
        innerStack.alignment = .center
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(innerStack)
 
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: InputTokens.height),
            innerStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: InputTokens.horizontalPadding),
            innerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -InputTokens.horizontalPadding),
            innerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: InputTokens.horizontalPadding),
            innerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -InputTokens.horizontalPadding)
        ])
 
        labelView.isHidden = true
        leadingIconView.isHidden = true
        trailingIconView.isHidden = true
    }
 
    private func setupDelegates() {
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        let leadingTap = UITapGestureRecognizer(target: self, action: #selector(leadingIconTapped))
        leadingIconView.addGestureRecognizer(leadingTap)
        
        let trailingTap = UITapGestureRecognizer(target: self, action: #selector(trailingIconTapped))
        trailingIconView.addGestureRecognizer(trailingTap)
    }
 
    // MARK: State
    func applyState(_ state: InputState) {
        currentState = state
        let style = InputStyle.style(for: state)
 
        containerView.layer.borderColor = style.borderColor?.cgColor
        containerView.backgroundColor = style.backgroundColor
        textField.textColor = style.textColor
        textField.isUserInteractionEnabled = style.isUserInteractionEnabled
        leadingIconView.tintColor = style.iconColor
        trailingIconView.tintColor = style.iconColor
 
        if let hint = style.hintMessage, !hint.isEmpty {
            hintLabel.text = hint
            hintLabel.textColor = style.hintColor
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
 
        updatePlaceholder()
    }
 
    /// Configure leading icon
    func setLeadingIcon(_ image: UIImage?) {
        leadingIconView.image = image?.withRenderingMode(.alwaysTemplate)
        leadingIconView.isHidden = (image == nil)
    }
 
    /// Configure trailing icon
    func setTrailingIcon(_ image: UIImage?) {
        trailingIconView.image = image?.withRenderingMode(.alwaysTemplate)
        trailingIconView.isHidden = (image == nil)
    }
 
    private func updatePlaceholder() {
        let style = InputStyle.style(for: currentState)
        guard let ph = placeholder else { return }
        textField.attributedPlaceholder = NSAttributedString(
            string: ph,
            attributes: [.foregroundColor: style.placeholderColor as Any]
        )
    }
 
    // MARK: Focus handling
    @objc private func textFieldDidBeginEditing() {
        guard case .error = currentState else {
            guard case .warning = currentState else {
                applyState(.focused)
                return
            }
            return
        }
    }
 
    @objc private func textFieldDidEndEditing() {
        guard case .focused = currentState else { return }
        let isEmpty = textField.text?.isEmpty ?? true
        applyState(isEmpty ? .defaultInput : .filled)
    }
    
    // MARK: Icon tap handlers
    @objc private func leadingIconTapped() {
        FeedbackGenerator.onFeedbackGenerator(.light)
        onLeadingIconTapped?()
    }
    
    @objc private func trailingIconTapped() {
        FeedbackGenerator.onFeedbackGenerator(.light)
        onTrailingIconTapped?()
    }
}
