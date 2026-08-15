//
//  TourBadgeStripView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// The row of chips overlaid on the bottom-left of a tour card's photo:
/// rating first, then the plain attribute chips.
final class TourBadgeStripView: UIView {
    private enum Layout {
        static let spacing: CGFloat = 6
    }

    private static let ratingIcon = UIImage(systemName: "star.fill")

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Layout.spacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(ratingText: String?, badges: [String]) {
        // Chips are rebuilt rather than recycled: a card shows at most three and
        // diffing them would cost more than it saves.
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        if let ratingText {
            stackView.addArrangedSubview(TagBadgeView(text: ratingText, icon: Self.ratingIcon))
        }

        badges.forEach { stackView.addArrangedSubview(TagBadgeView(text: $0)) }

        // Later chips yield first, so a long airfield name truncates instead of
        // shoving the seat count off the card.
        for (index, chip) in stackView.arrangedSubviews.enumerated() {
            chip.setContentCompressionResistancePriority(
                UILayoutPriority(UILayoutPriority.defaultHigh.rawValue - Float(index)),
                for: .horizontal
            )
        }
    }
}
