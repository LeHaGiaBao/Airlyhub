//
//  UITextField+StyleExample.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit
 
// MARK: - Example 1: Plain UITextField (lightweight, no label/hint)
class PlainTextFieldExampleVC: UIViewController {
    private let searchField = UITextField()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchField)
 
        searchField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(InputTokens.height)
        }
 
        // Set placeholder & apply default state
        searchField.placeholder = "Search..."
        searchField.applyStyle(.defaultInput)
 
        // Observe focus events to toggle state
        searchField.addTarget(self, action: #selector(onFocus), for: .editingDidBegin)
        searchField.addTarget(self, action: #selector(onBlur), for: .editingDidEnd)
    }
 
    @objc private func onFocus() { searchField.applyStyle(.focused) }
    @objc private func onBlur() {
        let isEmpty = searchField.text?.isEmpty ?? true
        searchField.applyStyle(isEmpty ? .defaultInput : .filled)
    }
}
 
// MARK: - Example 2: ZPInputField (full component)
class InputFieldExampleVC: UIViewController {
    // 1. Default + label + icon
    private let phoneField = TextField()
 
    // 2. With trailing search icon
    private let searchField = TextField()
 
    // 3. Error state
    private let emailField = TextField()
 
    // 4. Warning state
    private let amountField = TextField()
 
    // 5. Success state
    private let confirmField = TextField()
 
    // 6. Disabled
    private let disabledField = TextField()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
 
        let stack = UIStackView(arrangedSubviews: [
            phoneField,
            searchField,
            emailField,
            amountField,
            confirmField,
            disabledField
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
 
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
 
        configureFields()
    }
 
    private func configureFields() {
        // 1. Default with label + leading icon
        phoneField.label = "Phone number"
        phoneField.placeholder = "Enter phone number"
        phoneField.setLeadingIcon(UIImage(systemName: "phone"))
        phoneField.applyState(.defaultInput)
 
        // 2. Search with trailing icon
        searchField.label = "Search"
        searchField.placeholder = "Keyword..."
        searchField.setTrailingIcon(UIImage(systemName: "magnifyingglass"))
        searchField.applyState(.defaultInput)
 
        // 3. Error — after validation failure
        emailField.label = "Email"
        emailField.placeholder = "your@email.com"
        emailField.textField.text = "invalid-email"
        emailField.setTrailingIcon(UIImage(systemName: "xmark.circle.fill"))
        emailField.applyState(.error(message: "Please enter a valid email address."))
 
        // 4. Warning
        amountField.label = "Amount"
        amountField.placeholder = "0"
        amountField.textField.text = "9,999,999"
        amountField.applyState(.warning(message: "Amount exceeds your daily limit."))
 
        // 5. Success — after OTP verified
        confirmField.label = "OTP"
        confirmField.placeholder = "------"
        confirmField.textField.text = "123456"
        confirmField.setTrailingIcon(UIImage(systemName: "checkmark.circle.fill"))
        confirmField.applyState(.success)
 
        // 6. Disabled
        disabledField.label = "Account number"
        disabledField.placeholder = "Auto-filled"
        disabledField.textField.text = "0123456789"
        disabledField.applyState(.disabled)
    }
}
 
// MARK: - Example 3: Programmatic state switching (e.g. form validation)
class TransferFormVC: UIViewController {
    private let recipientField = TextField()
    private let submitButton = UIButton(type: .system)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
 
        // Layout (SnapKit)
        view.addSubview(recipientField)
        view.addSubview(submitButton)
 
        recipientField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        submitButton.snp.makeConstraints {
            $0.top.equalTo(recipientField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
 
        recipientField.label = "Recipient"
        recipientField.placeholder = "Enter phone or account"
        recipientField.setLeadingIcon(UIImage(systemName: "person"))
        recipientField.applyState(.defaultInput)
 
        submitButton.setTitle("Verify", for: .normal)
        submitButton.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
    }
 
    @objc private func onSubmit() {
        let text = recipientField.textField.text ?? ""
 
        if text.isEmpty {
            recipientField.applyState(.error(message: "Recipient cannot be empty."))
        } else if text.count < 10 {
            recipientField.applyState(.warning(message: "Number seems short. Please double-check."))
        } else {
            recipientField.applyState(.success)
        }
    }
}
 
