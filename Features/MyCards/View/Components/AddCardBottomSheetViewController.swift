//
//  AddCardBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

final class AddCardBottomSheetViewController: BaseBottomSheetViewController {
    var onSubmit: ((NewCardInput) -> Void)?
    var onCancel: (() -> Void)?

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    private let numberField = TextField()
    private let holderField = TextField()
    private let expiryField = TextField()
    private let cvvField = TextField()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("add_card", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    /// Brand indicator hosted in the number field's `rightView`, so UIKit reserves the
    /// space for it and long numbers never run underneath the logo.
    private let brandLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 24)
        imageView.isHidden = true
        return imageView
    }()

    private let brandFallbackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.textAlignment = .right
        label.frame = CGRect(x: 0, y: 0, width: 40, height: 24)
        label.isHidden = true
        return label
    }()

    private lazy var brandAccessoryView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 24))
        container.addSubview(brandLogoView)
        container.addSubview(brandFallbackLabel)
        return container
    }()

    private(set) var detectedBrand: CardBrand = .unknown

    init() {
        super.init(configuration: Configuration(
            showsHandle: true,
            avoidsKeyboard: true,
            animationOffset: 600
        ))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildContent() {
        setupUI()
        setupFields()
        setupEvents()
        updateSubmitState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        numberField.textField.becomeFirstResponder()
    }

    override func didTapDimming() {
        view.endEditing(true)
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }
}

// MARK: - UI
private extension AddCardBottomSheetViewController {
    func setupUI() {
        titleLabel.text = NSLocalizedString("new_card", comment: "")
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = AppColor.PrimaryColors.Gray.color800 ?? .label

        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = AppColor.PrimaryColors.Gray.color300

        let fieldStack = UIStackView(arrangedSubviews: [numberField, holderField])
        fieldStack.axis = .vertical
        fieldStack.spacing = 16

        let expiryCvvStack = UIStackView(arrangedSubviews: [expiryField, cvvField])
        expiryCvvStack.axis = .horizontal
        expiryCvvStack.spacing = 12
        expiryCvvStack.distribution = .fillEqually

        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(fieldStack)
        contentView.addSubview(expiryCvvStack)
        contentView.addSubview(submitButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualTo(closeButton.snp.leading).offset(-12)
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(28)
        }

        fieldStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        expiryCvvStack.snp.makeConstraints { make in
            make.top.equalTo(fieldStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(expiryCvvStack.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    func setupFields() {
        numberField.label = NSLocalizedString("card_number", comment: "")
        numberField.placeholder = NSLocalizedString("card_number_placeholder", comment: "")
        numberField.textField.keyboardType = .numberPad
        numberField.textField.textContentType = .creditCardNumber
        numberField.textField.rightView = brandAccessoryView
        numberField.textField.rightViewMode = .always

        holderField.label = NSLocalizedString("card_holder", comment: "")
        holderField.placeholder = NSLocalizedString("card_holder_placeholder", comment: "")
        holderField.textField.autocapitalizationType = .allCharacters
        holderField.textField.autocorrectionType = .no
        holderField.textField.textContentType = .name

        expiryField.label = NSLocalizedString("card_expiry", comment: "")
        expiryField.placeholder = NSLocalizedString("card_expiry_placeholder", comment: "")
        expiryField.textField.keyboardType = .numberPad

        cvvField.label = NSLocalizedString("card_cvv", comment: "")
        cvvField.placeholder = NSLocalizedString("card_cvv_placeholder", comment: "")
        cvvField.textField.keyboardType = .numberPad
        cvvField.textField.isSecureTextEntry = true
        // Secure fields wipe themselves on re-focus by default, which would silently
        // clear a CVV the user already typed when they tab back to fix something else.
        cvvField.textField.clearsOnBeginEditing = false
        // Keeps the keyboard from learning or suggesting the security code.
        cvvField.textField.textContentType = .oneTimeCode

        [numberField, holderField, expiryField, cvvField].forEach {
            $0.textField.delegate = self
        }
    }

    func setupEvents() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)

        [numberField, holderField, expiryField, cvvField].forEach {
            $0.textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            $0.textField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        }
    }
}

// MARK: - Actions
private extension AddCardBottomSheetViewController {
    @objc func didTapClose() {
        view.endEditing(true)
        dismissSheet { [weak self] in
            self?.onCancel?()
        }
    }

    @objc func editingChanged() {
        updateSubmitState()
    }

    /// Errors surface on blur rather than on every keystroke, so a half-typed number
    /// isn't flagged as invalid while the user is still typing it.
    @objc func editingDidEnd(_ textField: UITextField) {
        switch textField {
        case numberField.textField:
            apply(CardValidation.validCardNumber(textField.text), to: numberField)
        case holderField.textField:
            apply(CardValidation.validHolderName(textField.text), to: holderField)
        case expiryField.textField:
            apply(CardValidation.validExpiry(textField.text), to: expiryField)
        case cvvField.textField:
            apply(CardValidation.validCVV(textField.text, brand: detectedBrand), to: cvvField)
        default:
            break
        }
    }

    func apply(_ result: ValidationResult, to field: TextField) {
        let isEmpty = field.textField.text?.isEmpty ?? true

        if result.isValid {
            field.applyState(isEmpty ? .defaultInput : .filled)
        } else if isEmpty {
            // Don't scold the user for a field they haven't reached yet.
            field.applyState(.defaultInput)
        } else {
            field.applyState(.error(message: result.errorMessage))
        }
    }

    func updateSubmitState() {
        let isValid = CardValidation.validCardNumber(numberField.textField.text).isValid
            && CardValidation.validHolderName(holderField.textField.text).isValid
            && CardValidation.validExpiry(expiryField.textField.text).isValid
            && CardValidation.validCVV(cvvField.textField.text, brand: detectedBrand).isValid

        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1.0 : 0.5
    }

    @objc func didTapSubmit() {
        let digits = (numberField.textField.text ?? "").filter(\.isNumber)
        let expiryDigits = (expiryField.textField.text ?? "").filter(\.isNumber)

        guard CardValidation.validCardNumber(digits).isValid,
              CardValidation.validExpiry(expiryDigits).isValid,
              expiryDigits.count == 4,
              let month = Int(expiryDigits.prefix(2)),
              let shortYear = Int(expiryDigits.suffix(2)) else { return }

        let input = NewCardInput(
            number: digits,
            holderName: (holderField.textField.text ?? "")
                .trimmingCharacters(in: .whitespaces)
                .uppercased(),
            expMonth: month,
            expYear: 2000 + shortYear,
            cvv: cvvField.textField.text ?? ""
        )

        // Clear the sensitive fields immediately rather than waiting for deallocation.
        numberField.textField.text = nil
        cvvField.textField.text = nil

        view.endEditing(true)
        dismissSheet { [weak self] in
            self?.onSubmit?(input)
        }
    }
}

// MARK: - Brand detection
private extension AddCardBottomSheetViewController {
    func updateBrand(_ brand: CardBrand) {
        guard brand != detectedBrand else { return }
        detectedBrand = brand

        if let logo = brand.logo {
            brandLogoView.image = logo
            brandLogoView.isHidden = false
            brandFallbackLabel.isHidden = true
        } else {
            brandLogoView.isHidden = true
            brandFallbackLabel.isHidden = (brand == .unknown)
            brandFallbackLabel.text = brand == .unknown ? nil : brand.shortName
        }

        // Amex takes a 4-digit CID; every other scheme takes 3. Switching brands can
        // therefore leave an over-long code behind, so trim it.
        if let cvv = cvvField.textField.text, cvv.count > brand.cvvLength {
            cvvField.textField.text = String(cvv.prefix(brand.cvvLength))
        }
        cvvField.placeholder = brand == .amex
            ? NSLocalizedString("card_cid_placeholder", comment: "")
            : NSLocalizedString("card_cvv_placeholder", comment: "")
    }
}

// MARK: - UITextFieldDelegate
extension AddCardBottomSheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // The three numeric fields accept digits and deletions only.
        if textField !== holderField.textField {
            guard string.isEmpty || string.allSatisfy(\.isNumber) else { return false }
        }

        switch textField {
        case numberField.textField:
            applyNumberFormatting(textField, range: range, replacement: string)
            return false

        case expiryField.textField:
            applyExpiryFormatting(textField, range: range, replacement: string)
            return false

        case cvvField.textField:
            guard let updated = updatedText(for: textField, range: range, replacement: string) else {
                return false
            }
            return updated.count <= detectedBrand.cvvLength

        case holderField.textField:
            guard let updated = updatedText(for: textField, range: range, replacement: string) else {
                return false
            }
            return updated.count <= 26

        default:
            return true
        }
    }

    private func updatedText(for textField: UITextField,
                             range: NSRange,
                             replacement: String) -> String? {
        let current = textField.text ?? ""
        guard let textRange = Range(range, in: current) else { return nil }
        return current.replacingCharacters(in: textRange, with: replacement)
    }

    private func applyNumberFormatting(_ textField: UITextField,
                                       range: NSRange,
                                       replacement: String) {
        guard let updated = updatedText(for: textField, range: range, replacement: replacement) else { return }

        // The count of digits before the caret is the one thing that survives reformatting,
        // so it — not the raw offset — is what the caret is restored from.
        let cursorOffset = range.location + replacement.count
        let digitsBeforeCursor = updated.prefix(cursorOffset).filter(\.isNumber).count

        let brand = CardBrand.detect(from: updated)
        let formatted = CardFormatter.formatNumber(updated, brand: brand)
        textField.text = formatted

        var seenDigits = 0
        var index = formatted.startIndex
        while index < formatted.endIndex, seenDigits < digitsBeforeCursor {
            if formatted[index].isNumber { seenDigits += 1 }
            index = formatted.index(after: index)
        }
        let offset = formatted.distance(from: formatted.startIndex, to: index)
        if let position = textField.position(from: textField.beginningOfDocument, offset: offset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }

        updateBrand(brand)

        // Setting `.text` programmatically doesn't fire `.editingChanged`.
        updateSubmitState()
    }

    private func applyExpiryFormatting(_ textField: UITextField,
                                       range: NSRange,
                                       replacement: String) {
        guard let updated = updatedText(for: textField, range: range, replacement: replacement) else { return }
        textField.text = CardFormatter.formatExpiry(updated)
        updateSubmitState()
    }
}
