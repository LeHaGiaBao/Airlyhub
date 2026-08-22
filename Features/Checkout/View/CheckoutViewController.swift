//
//  CheckoutViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// Payment form: a card number/expiry/CVV entry — the same three fields
/// `AddCardBottomSheetViewController` collects, minus the holder name the design
/// doesn't ask for here — plus a row of previously saved cards a tap can pay with
/// instead of typing one in.
///
/// Selecting a saved card and typing a new one are mutually exclusive: choosing a
/// row locks the number/expiry fields to that card's own values and clears the CVV
/// (never stored, so it always has to be re-entered), tapping the same row again
/// releases the fields back to a blank new-card entry.
final class CheckoutViewController: BaseViewController {
    var presenter: CheckoutPresenterProtocol!

    private enum Layout {
        static let navigatorHeight: CGFloat = 56
        static let contentPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let checkboxSize: CGFloat = 22
    }

    /// Held so the keyboard observer can lift the Pay button clear of the keypad —
    /// the design shows it sitting directly above the keys, not buried under them.
    private var payButtonBottomConstraint: Constraint?

    private let topNavigatorVC = TopNavigatorView(topNavigatorTile: NSLocalizedString("checkout_title", comment: ""))

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.keyboardDismissMode = .interactive
        return scroll
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.sectionSpacing
        return stack
    }()

    private let numberField = TextField()
    private let expiryField = TextField()
    private let cvvField = TextField()

    private static let brandBadgeInset: CGFloat = 8

    private let brandLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            origin: CGPoint(x: CheckoutViewController.brandBadgeInset, y: 0),
            size: CardBrand.logoSize
        )
        imageView.isHidden = true
        return imageView
    }()

    private let brandFallbackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.textAlignment = .right
        label.frame = CGRect(
            origin: CGPoint(x: CheckoutViewController.brandBadgeInset, y: 0),
            size: CardBrand.logoSize
        )
        label.isHidden = true
        return label
    }()

    private lazy var brandAccessoryView: UIView = {
        let container = UIView(frame: CGRect(
            x: 0, y: 0,
            width: CardBrand.logoSize.width + Self.brandBadgeInset,
            height: CardBrand.logoSize.height
        ))
        container.addSubview(brandLogoView)
        container.addSubview(brandFallbackLabel)
        return container
    }()

    private var detectedBrand: CardBrand = .unknown

    private lazy var expiryCvvStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [expiryField, cvvField])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var saveCardCheckbox: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.PrimaryColors.Primary.color500
        // The glyph is the whole control, so it must not swallow the row's tap and
        // then do nothing with it — the row's gesture recogniser owns the toggle.
        button.isUserInteractionEnabled = false
        return button
    }()

    private let saveCardLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("checkout_save_card", comment: "")
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private lazy var saveCardRow: UIStackView = {
        // The trailing spacer keeps the checkbox and its label hugging the left
        // edge — `contentStack` fills its arranged views to full width, which
        // without it would stretch the label across the screen.
        let stack = UIStackView(arrangedSubviews: [saveCardCheckbox, saveCardLabel, UIView()])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.isUserInteractionEnabled = true
        return stack
    }()

    private var isSaveCardChecked = true {
        didSet { updateCheckboxImage() }
    }

    private let savedCardsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("checkout_saved_cards", comment: "")
        label.applyTypography(.textMd(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private let savedCardsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var savedCardsSection: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [savedCardsTitleLabel, savedCardsStack])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    /// Plain `UIButton()`, not `.system`: `applyButtonStyle` drives every state
    /// through a `UIButton.Configuration`, and a system button layers its own
    /// tint-based dimming on top of that — the two disagree about what "disabled"
    /// looks like. Every other styled button in the app is built this way.
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("checkout_pay", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private var savedCards: [CardModel] = []
    private var selectedSavedCard: CardModel?

    /// Set while a booking write is in flight. Kept here rather than only in the
    /// presenter because `updatePayState` is the single place that decides whether
    /// the button is tappable, and it has to weigh this against form validity —
    /// two writers to `isEnabled` is how the button ends up stuck.
    private var isPaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedTopNavigator()
        setupFields()
        setupEvents()
        observeKeyboard()
        savedCardsSection.isHidden = true
        updateCheckboxImage()
        updatePayState()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(payButton)

        contentStack.addArrangedSubview(numberField)
        contentStack.addArrangedSubview(expiryCvvStack)
        contentStack.addArrangedSubview(saveCardRow)
        contentStack.addArrangedSubview(savedCardsSection)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Layout.navigatorHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(payButton.snp.top).offset(-Layout.contentPadding)
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide).offset(Layout.contentPadding)
            make.bottom.equalTo(scrollView.contentLayoutGuide).offset(-Layout.contentPadding)
            make.left.right.equalTo(scrollView.frameLayoutGuide).inset(Devices.paddingHorizontal)
        }

        saveCardCheckbox.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.checkboxSize)
        }

        // No height here: `applyButtonStyle` activates its own `heightAnchor` for
        // the button size, and a second fixed height fights it — 50 against 52 is
        // unsatisfiable, and UIKit breaks one of them at random.
        payButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            payButtonBottomConstraint = make.bottom
                .equalTo(view.safeAreaLayoutGuide)
                .offset(-Layout.contentPadding)
                .constraint
        }
    }

    private func embedTopNavigator() {
        addChild(topNavigatorVC)
        view.addSubview(topNavigatorVC.view)

        topNavigatorVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Layout.navigatorHeight)
        }

        topNavigatorVC.didMove(toParent: self)
        topNavigatorVC.onCloseAction = { [weak self] in
            self?.presenter.didTapBack()
        }
    }

    private func setupFields() {
        numberField.placeholder = NSLocalizedString("card_number_placeholder", comment: "")
        numberField.textField.keyboardType = .numberPad
        numberField.textField.textContentType = .creditCardNumber
        numberField.textField.rightView = brandAccessoryView
        numberField.textField.rightViewMode = .always

        expiryField.placeholder = NSLocalizedString("card_expiry_placeholder", comment: "")
        expiryField.textField.keyboardType = .numberPad

        cvvField.placeholder = NSLocalizedString("card_cvv_placeholder", comment: "")
        cvvField.textField.keyboardType = .numberPad
        cvvField.textField.isSecureTextEntry = true
        cvvField.textField.clearsOnBeginEditing = false
        cvvField.textField.textContentType = .oneTimeCode

        [numberField, expiryField, cvvField].forEach { $0.textField.delegate = self }
    }

    private func setupEvents() {
        [numberField, expiryField, cvvField].forEach {
            $0.textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }

        let saveCardTap = UITapGestureRecognizer(target: self, action: #selector(saveCardRowTapped))
        saveCardRow.addGestureRecognizer(saveCardTap)

        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
    }

    // MARK: - Saved card selection

    private func selectSavedCard(_ card: CardModel) {
        selectedSavedCard = (selectedSavedCard?.id == card.id) ? nil : card
        refreshCardModeUI()
    }

    private func refreshCardModeUI() {
        let usingSavedCard = selectedSavedCard != nil
        saveCardRow.isHidden = usingSavedCard
        cvvField.textField.text = nil

        if let card = selectedSavedCard {
            numberField.textField.text = CardFormatter.masked(last4: card.last4, brand: card.brand)
            expiryField.textField.text = card.expiryDisplay
            detectedBrand = card.brand
            numberField.applyState(.disabled)
            expiryField.applyState(.disabled)
        } else {
            numberField.textField.text = nil
            expiryField.textField.text = nil
            detectedBrand = .unknown
            numberField.applyState(.defaultInput)
            expiryField.applyState(.defaultInput)
        }

        cvvField.applyState(.defaultInput)
        updateBrand(detectedBrand)
        updateSavedCardRows()
        updatePayState()
    }

    private func updateSavedCardRows() {
        savedCardsStack.arrangedSubviews.enumerated().forEach { index, view in
            guard let row = view as? SavedCardRowView, savedCards.indices.contains(index) else { return }
            let card = savedCards[index]
            row.configure(with: card, isSelected: card.id == selectedSavedCard?.id)
        }
    }

    // MARK: - Validation

    /// The only writer to the Pay button's enabled state. Everything that could
    /// change it — a keystroke, picking a saved card, a booking starting or
    /// failing — routes through here rather than setting `isEnabled` itself.
    private func updatePayState() {
        let isEnabled = isFormValid && !isPaying
        payButton.isEnabled = isEnabled
        // `applyButtonStyle` already repaints the disabled state through the
        // button's configuration; the alpha is what the rest of the app uses to
        // make that reading unmistakable — see `AddCardBottomSheetViewController`.
        payButton.alpha = isEnabled ? 1.0 : 0.5
    }

    /// A saved card only needs its security code re-entered — the number and
    /// expiry come from the stored record and its fields are locked.
    private var isFormValid: Bool {
        if let card = selectedSavedCard {
            return CardValidation.validCVV(cvvField.textField.text, brand: card.brand).isValid
        }
        return CardValidation.validCardNumber(numberField.textField.text).isValid
            && CardValidation.validExpiry(expiryField.textField.text).isValid
            && CardValidation.validCVV(cvvField.textField.text, brand: detectedBrand).isValid
    }

    private func updateBrand(_ brand: CardBrand) {
        if let logo = brand.logo {
            brandLogoView.image = logo
            brandLogoView.isHidden = false
            brandFallbackLabel.isHidden = true
        } else {
            brandLogoView.isHidden = true
            brandFallbackLabel.isHidden = (brand == .unknown)
            brandFallbackLabel.text = brand == .unknown ? nil : brand.shortName
        }

        if let cvv = cvvField.textField.text, cvv.count > brand.cvvLength {
            cvvField.textField.text = String(cvv.prefix(brand.cvvLength))
        }
    }

    private func updateCheckboxImage() {
        let symbol = isSaveCardChecked ? "checkmark.square.fill" : "square"
        saveCardCheckbox.setImage(UIImage(systemName: symbol), for: .normal)
    }

    // MARK: - Actions

    @objc private func editingChanged() {
        updatePayState()
    }

    @objc private func saveCardRowTapped() {
        isSaveCardChecked.toggle()
    }

    // MARK: - Keyboard

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    /// `willChangeFrame` rather than the show/hide pair, matching
    /// `CustomerServiceView` — it also tracks the keypad swapping height rather
    /// than only appearing and disappearing.
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardFrame = view.convert(endFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY)
        // The button already sits above the home indicator, so only the part of
        // the keyboard that reaches past the safe area needs compensating for —
        // subtracting it twice would leave a visible gap under the keys.
        let extraLift = max(0, overlap - view.safeAreaInsets.bottom)
        payButtonBottomConstraint?.update(offset: -(Layout.contentPadding + extraLift))

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: UInt(curveValue) << 16),
            animations: { self.view.layoutIfNeeded() }
        )
    }

    @objc private func payTapped() {
        view.endEditing(true)

        if let card = selectedSavedCard {
            guard CardValidation.validCVV(cvvField.textField.text, brand: card.brand).isValid else { return }
            presenter.didTapPay(with: .savedCard(card))
            return
        }

        let digits = (numberField.textField.text ?? "").filter(\.isNumber)
        let expiryDigits = (expiryField.textField.text ?? "").filter(\.isNumber)

        guard CardValidation.validCardNumber(digits).isValid,
              CardValidation.validExpiry(expiryDigits).isValid,
              expiryDigits.count == 4,
              let month = Int(expiryDigits.prefix(2)),
              let shortYear = Int(expiryDigits.suffix(2)) else { return }

        let input = NewCardInput(
            number: digits,
            // The design collects no holder name on this screen — nothing ever
            // surfaces it back to the user, so a fixed label satisfies `CardDTO`'s
            // required field without inventing a UI element the mockup doesn't have.
            holderName: NSLocalizedString("checkout_default_card_holder", comment: ""),
            expMonth: month,
            expYear: 2000 + shortYear,
            cvv: cvvField.textField.text ?? ""
        )

        presenter.didTapPay(with: .newCard(input, save: isSaveCardChecked))
    }
}

// MARK: - CheckoutViewProtocol
extension CheckoutViewController: CheckoutViewProtocol {
    func showSavedCards(_ cards: [CardModel]) {
        savedCards = cards
        savedCardsSection.isHidden = cards.isEmpty

        savedCardsStack.arrangedSubviews.forEach {
            savedCardsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        cards.forEach { card in
            let row = SavedCardRowView()
            row.configure(with: card, isSelected: card.id == selectedSavedCard?.id)
            row.onTap = { [weak self] id in
                guard let self, let card = self.savedCards.first(where: { $0.id == id }) else { return }
                self.selectSavedCard(card)
            }
            savedCardsStack.addArrangedSubview(row)
        }
    }

    func setPaying(_ isPaying: Bool) {
        self.isPaying = isPaying
        // Not `isEnabled = !isPaying`: a booking that failed must leave the button
        // disabled if the form is also invalid, which only `updatePayState` knows.
        updatePayState()
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}

// MARK: - UITextFieldDelegate
extension CheckoutViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard string.isEmpty || string.allSatisfy(\.isNumber) else { return false }

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

    private func applyNumberFormatting(_ textField: UITextField, range: NSRange, replacement: String) {
        guard let updated = updatedText(for: textField, range: range, replacement: replacement) else { return }

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

        detectedBrand = brand
        updateBrand(brand)
        updatePayState()
    }

    private func applyExpiryFormatting(_ textField: UITextField, range: NSRange, replacement: String) {
        guard let updated = updatedText(for: textField, range: range, replacement: replacement) else { return }
        textField.text = CardFormatter.formatExpiry(updated)
        updatePayState()
    }
}
