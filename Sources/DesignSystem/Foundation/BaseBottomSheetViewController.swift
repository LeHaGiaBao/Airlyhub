//
//  BaseBottomSheetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//

import UIKit

/// Shared chrome for bottom sheets: dimming backdrop, rounded sheet container,
/// slide up/down animation, tap-to-dismiss, optional drag handle and keyboard avoidance.
class BaseBottomSheetViewController: UIViewController {
    struct Configuration {
        var cornerRadius: CGFloat = 20
        var dimmingAlpha: CGFloat = 0.35
        var sheetBackgroundColor: UIColor = .white
        var showsHandle: Bool = false
        var handleColor: UIColor = AppColor.PrimaryColors.Gray.color200 ?? UIColor(white: 0.8, alpha: 1)
        var avoidsKeyboard: Bool = false
        var animationOffset: CGFloat = 400
        var dismissFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle? = .soft
    }

    let configuration: Configuration

    let dimmingView = UIView()
    let sheetContainer = UIView()
    let contentView = UIView()

    private let handleBar = UIView()
    private var sheetBottomConstraint: NSLayoutConstraint!

    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupChrome()
        buildContent()
        if configuration.avoidsKeyboard {
            observeKeyboard()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }

    deinit {
        if configuration.avoidsKeyboard {
            NotificationCenter.default.removeObserver(self)
        }
    }

    func buildContent() {}

    func didTapDimming() {
        dismissSheet(completion: nil)
    }

    func dismissSheet(feedback: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
                      completion: (() -> Void)? = nil) {
        let feedbackStyle = feedback ?? configuration.dismissFeedbackStyle
        animateOut {
            self.dismiss(animated: false) {
                if let feedbackStyle { FeedbackGenerator.onFeedbackGenerator(feedbackStyle) }
                completion?()
            }
        }
    }
}

private extension BaseBottomSheetViewController {
    func setupChrome() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(configuration.dimmingAlpha)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDimmingTap)))

        sheetContainer.backgroundColor = configuration.sheetBackgroundColor
        sheetContainer.layer.cornerRadius = configuration.cornerRadius
        sheetContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetContainer.clipsToBounds = true
        sheetContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dimmingView)
        view.addSubview(sheetContainer)
        sheetContainer.addSubview(contentView)

        sheetBottomConstraint = sheetContainer.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: configuration.animationOffset)

        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sheetContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetBottomConstraint,

            contentView.leadingAnchor.constraint(equalTo: sheetContainer.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: sheetContainer.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: sheetContainer.bottomAnchor)
        ])

        if configuration.showsHandle {
            handleBar.backgroundColor = configuration.handleColor
            handleBar.layer.cornerRadius = 2.5
            handleBar.translatesAutoresizingMaskIntoConstraints = false
            sheetContainer.addSubview(handleBar)
            NSLayoutConstraint.activate([
                handleBar.topAnchor.constraint(equalTo: sheetContainer.topAnchor, constant: 10),
                handleBar.centerXAnchor.constraint(equalTo: sheetContainer.centerXAnchor),
                handleBar.widthAnchor.constraint(equalToConstant: 36),
                handleBar.heightAnchor.constraint(equalToConstant: 5),
                contentView.topAnchor.constraint(equalTo: handleBar.bottomAnchor)
            ])
        } else {
            contentView.topAnchor.constraint(equalTo: sheetContainer.topAnchor).isActive = true
        }
    }

    @objc func handleDimmingTap() {
        didTapDimming()
    }
}

private extension BaseBottomSheetViewController {
    func animateIn() {
        view.layoutIfNeeded()
        sheetBottomConstraint.constant = 0
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut]
        ) {
            self.dimmingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func animateOut(completion: @escaping () -> Void) {
        sheetBottomConstraint.constant = sheetContainer.bounds.height
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseIn]
        ) {
            self.dimmingView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}

private extension BaseBottomSheetViewController {
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        sheetBottomConstraint.constant = -frame.height
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        sheetBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
}
