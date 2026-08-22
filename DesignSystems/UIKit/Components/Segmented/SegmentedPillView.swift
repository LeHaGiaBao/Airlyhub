//
//  SegmentedPillView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// A row of rounded pills where exactly one is selected — the "Air tours / Flights"
/// switch on Favorites.
///
/// Not a `UISegmentedControl`: that draws a single joined track with a sliding
/// thumb, while the design has separate pills that size to their own titles and
/// leave the trailing space empty. Reproducing it through the segmented control's
/// appearance proxy costs more than owning two buttons.
final class SegmentedPillView: UIView {
    private enum Layout {
        static let height: CGFloat = 36
        static let spacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
    }

    /// Fires only for a user tap, not for `select(_:)` — a caller that sets the
    /// index already knows it changed, and echoing it back invites a loop.
    var onSelect: ((Int) -> Void)?

    private(set) var selectedIndex: Int = 0

    private var buttons: [UIButton] = []

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        // Pills hug their titles and the row is left-aligned, so the stack must not
        // stretch them to fill the width.
        stack.alignment = .center
        stack.spacing = Layout.spacing
        return stack
    }()

    init(titles: [String], selectedIndex: Int = 0) {
        super.init(frame: .zero)
        self.selectedIndex = selectedIndex
        setupUI(titles: titles)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Moves the selection without notifying — for restoring state.
    func select(_ index: Int) {
        guard buttons.indices.contains(index), index != selectedIndex else { return }
        selectedIndex = index
        refreshSelection()
    }

    // MARK: - Setup

    private func setupUI(titles: [String]) {
        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            // Trailing is an inequality so the row ends after the last pill instead
            // of the pills stretching across the screen.
            make.right.lessThanOrEqualToSuperview()
        }

        buttons = titles.enumerated().map { index, title in
            let button = makePill(title: title)
            button.tag = index
            button.isSelected = index == selectedIndex
            button.addTarget(self, action: #selector(pillTapped), for: .touchUpInside)
            stack.addArrangedSubview(button)
            return button
        }
    }

    private func makePill(title: String) -> UIButton {
        let button = UIButton(type: .custom)

        var config = UIButton.Configuration.filled()
        config.title = title
        config.cornerStyle = .fixed
        config.background.cornerRadius = 8
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Layout.horizontalPadding,
            bottom: 0,
            trailing: Layout.horizontalPadding
        )
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = .systemFont(ofSize: 15, weight: .semibold)
            return updated
        }
        button.configuration = config

        // Colours come from the update handler rather than being baked into the
        // configuration above, so a selection change repaints both pills without
        // rebuilding them. Same pattern as `applyButtonStyle`.
        button.configurationUpdateHandler = { button in
            var updated = button.configuration
            updated?.background.backgroundColor = button.isSelected
                ? AppColor.PrimaryColors.Primary.color500
                : AppColor.PrimaryColors.Gray.color100
            updated?.baseForegroundColor = button.isSelected
                ? AppColor.PrimaryColors.Gray.color25
                : AppColor.PrimaryColors.Gray.color700
            button.configuration = updated
        }

        button.snp.makeConstraints { make in
            make.height.equalTo(Layout.height)
        }

        return button
    }

    private func refreshSelection() {
        buttons.enumerated().forEach { index, button in
            button.isSelected = index == selectedIndex
        }
    }

    @objc private func pillTapped(_ sender: UIButton) {
        guard sender.tag != selectedIndex else { return }
        selectedIndex = sender.tag
        refreshSelection()
        FeedbackGenerator.onFeedbackGenerator(.soft)
        onSelect?(sender.tag)
    }
}
