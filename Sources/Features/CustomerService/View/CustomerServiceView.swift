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

private extension CustomerServiceView {
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

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

            if didGrow {
                tableView.layoutIfNeeded()
                scrollToBottom(animated: true)
            }

        case .failed(let message):
            activityIndicator.stopAnimating()
            tableView.isHidden = true
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

extension CustomerServiceView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }

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
                self.presenter.sendTapped(text: self.inputBar.text, attachment: draft)
            }
        }
    }
}
