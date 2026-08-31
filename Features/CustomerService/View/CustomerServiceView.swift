//
//  CustomerServiceView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import SnapKit
import PhotosUI

final class CustomerServiceView: BaseViewController {
    private let presenter: CustomerServicePresenterProtocol
    private let router: CustomerServiceRouterProtocol
    private let loadAttachment: ChatAttachmentLoader
    private let topNavigatorVC: TopNavigatorView

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputBar = ChatInputBar()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let errorLabel = UILabel()

    private var items: [ChatItem] = []
    private var inputBarBottomConstraint: Constraint?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: CustomerServicePresenterProtocol,
         router: CustomerServiceRouterProtocol,
         loadAttachment: @escaping ChatAttachmentLoader) {
        self.presenter = presenter
        self.router = router
        self.loadAttachment = loadAttachment
        self.topNavigatorVC = TopNavigatorView(
            topNavigatorTile: NSLocalizedString("customer_service", comment: "")
        )
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        embedTopNavigator()
        setupTableView()
        setupInputBar()
        observeKeyboard()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        inputBar.resignFirstResponder()
    }
}

// MARK: - UI
private extension CustomerServiceView {
    func setupUI() {
        view.backgroundColor = .systemBackground

        errorLabel.applyTypography(.textSm(weight: .regular))
        errorLabel.textColor = AppColor.PrimaryColors.Gray.color500
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        activityIndicator.hidesWhenStopped = true
    }

    func embedTopNavigator() {
        addChild(topNavigatorVC)
        view.addSubview(topNavigatorVC.view)
        topNavigatorVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }

        topNavigatorVC.didMove(toParent: self)
        topNavigatorVC.onCloseAction = { [weak self] in
            self?.presenter.dismiss()
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        // Dragging down through the thread puts the keyboard away, which is what the
        // gesture means in every other chat app.
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseIdentifier)
        tableView.register(ChatDaySeparatorCell.self, forCellReuseIdentifier: ChatDaySeparatorCell.reuseIdentifier)

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
    }

    func setupInputBar() {
        view.addSubview(inputBar)

        // Pinned to the view's own bottom edge rather than the safe area: when the
        // keyboard raises it, the bar's internal safe-area inset collapses on its own,
        // so the home-indicator gap appears only while the keyboard is down.
        inputBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            inputBarBottomConstraint = make.bottom.equalToSuperview().constraint
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topNavigatorVC.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBar.snp.top)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }

        errorLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalTo(tableView).inset(32)
        }

        inputBar.onSend = { [weak self] text in
            self?.presenter.sendTapped(text: text, attachment: nil)
        }

        inputBar.onAttach = { [weak self] in
            guard let self else { return }
            self.router.presentPhotoPicker(delegate: self)
        }
    }
}

// MARK: - Keyboard
private extension CustomerServiceView {
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    /// Uses `willChangeFrame` rather than the show/hide pair so the bar also tracks the
    /// keyboard swapping height — an emoji plane or a hardware keyboard connecting.
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardFrame = view.convert(endFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY)
        inputBarBottomConstraint?.update(offset: -overlap)

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            // The keyboard's own curve is a private value outside `UIView.AnimationCurve`;
            // shifting it into the options mask is how it gets matched exactly.
            options: UIView.AnimationOptions(rawValue: UInt(curveValue) << 16),
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.scrollToBottom(animated: false)
            }
        )
    }

    func scrollToBottom(animated: Bool) {
        guard !items.isEmpty else { return }
        let lastRow = IndexPath(row: items.count - 1, section: 0)
        tableView.scrollToRow(at: lastRow, at: .bottom, animated: animated)
    }
}

// MARK: - CustomerServiceViewProtocol
extension CustomerServiceView: CustomerServiceViewProtocol {
    func render(_ state: CustomerServiceViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = true
            inputBar.isHidden = true

        case .loaded(let items):
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = false
            inputBar.isHidden = false

            let didGrow = items.count > self.items.count
            self.items = items
            tableView.reloadData()

            // Only follow the thread when it actually grew. Reloading for an edit — a
            // pending message getting its real timestamp — must not yank the user away
            // from wherever they were reading.
            if didGrow {
                tableView.layoutIfNeeded()
                scrollToBottom(animated: true)
            }

        case .failed(let message):
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            // The thread couldn't be opened at all, so there is nothing to send into.
            inputBar.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message
            errorLabel.applyTypography(.textSm(weight: .regular))
        }
    }

    func clearInput() {
        inputBar.clear()
    }

    func setSending(_ isSending: Bool) {
        inputBar.setSending(isSending)
    }

    func showToast(_ message: String, style: ToastStyle) {
        ToastView.show(message, style: style, in: view)
    }
}

// MARK: - UITableViewDataSource
extension CustomerServiceView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .daySeparator(_, let title):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatDaySeparatorCell.reuseIdentifier,
                for: indexPath
            ) as? ChatDaySeparatorCell else {
                return UITableViewCell()
            }
            cell.configure(title: title)
            return cell

        case .message(let item):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatMessageCell.reuseIdentifier,
                for: indexPath
            ) as? ChatMessageCell else {
                return UITableViewCell()
            }
            cell.configure(with: item,
                           maxWidth: tableView.bounds.width,
                           loadAttachment: loadAttachment)
            return cell
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension CustomerServiceView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }

            // Resize off the main thread — a full-resolution photo is expensive to
            // re-render and this runs on the item provider's queue already.
            let resized = image.downscaled(toMaxDimension: CustomerServiceLimits.attachmentMaxDimension)
            guard let data = resized.jpegData(compressionQuality: CustomerServiceLimits.attachmentJPEGQuality) else {
                return
            }

            let draft = ChatAttachmentDraft(
                data: data,
                contentType: "image/jpeg",
                name: NSLocalizedString("chat_attachment_photo_name", comment: "")
            )

            DispatchQueue.main.async {
                guard let self else { return }
                // Whatever is already typed rides along with the photo, so the user
                // doesn't lose a half-written sentence by attaching a screenshot.
                self.presenter.sendTapped(text: self.inputBar.text, attachment: draft)
            }
        }
    }
}
