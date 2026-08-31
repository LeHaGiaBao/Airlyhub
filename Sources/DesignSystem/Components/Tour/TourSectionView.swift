//
//  TourSectionView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// A list of tour cards with a "Show more" button underneath — the "Air tours"
/// block on Explore, the "Search results" block on Flights, and the saved list on
/// Favorites, which uses it untitled and without paging.
final class TourSectionView: UIView {
    private enum Layout {
        static let titleSpacing: CGFloat = 20
        static let cardSpacing: CGFloat = 20
        static let buttonSpacing: CGFloat = 24
        static let separatorHeight: CGFloat = 1
    }

    var onSelectItem: ((String) -> Void)?
    var onToggleFavorite: ((String) -> Void)?
    var onShowMore: (() -> Void)?

    private var cards: [String: TourCardView] = [:]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.applyTypography(.textXl(weight: .bold))
        label.isHidden = true
        return label
    }()

    private let cardsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.cardSpacing
        return stack
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tour_search_empty", comment: "")
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.applyTypography(.textSm(weight: .regular))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("show_more", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        button.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var showMoreSeparator: UIView = {
        let separator = makeSeparator()
        separator.isHidden = true
        return separator
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, cardsStack, emptyLabel, showMoreSeparator, showMoreButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.setCustomSpacing(Layout.titleSpacing, after: titleLabel)
        stack.setCustomSpacing(Layout.buttonSpacing, after: cardsStack)
        stack.setCustomSpacing(Layout.buttonSpacing, after: emptyLabel)
        stack.setCustomSpacing(Layout.buttonSpacing, after: showMoreSeparator)
        return stack
    }()

    init(title: String) {
        super.init(frame: .zero)
        setupUI()
        self.title = title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.setText(newValue)
            titleLabel.isHidden = newValue?.isEmpty ?? true
        }
    }

    var emptyMessage: String? {
        get { emptyLabel.text }
        set { emptyLabel.setText(newValue) }
    }

    func configure(with items: [TourCardModel], hasMore: Bool) {
        clear()
        append(items, hasMore: hasMore)
    }

    func setLoading() {
        clear()
        emptyLabel.isHidden = true
        showMoreButton.isHidden = true
        showMoreSeparator.isHidden = true
    }

    private func clear() {
        cards.removeAll()
        cardsStack.arrangedSubviews.forEach {
            cardsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func append(_ items: [TourCardModel], hasMore: Bool) {
        for item in items {
            if !cardsStack.arrangedSubviews.isEmpty {
                cardsStack.addArrangedSubview(makeSeparator())
            }

            let card = TourCardView()
            card.configure(with: item)
            card.onToggleFavorite = { [weak self] id in
                self?.onToggleFavorite?(id)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
            tap.delegate = self
            card.addGestureRecognizer(tap)
            cards[item.id] = card
            cardsStack.addArrangedSubview(card)
        }

        emptyLabel.isHidden = !cards.isEmpty
        showMoreButton.isHidden = !hasMore
        showMoreSeparator.isHidden = !hasMore || cards.isEmpty
    }

    func setFavorite(_ isFavorite: Bool, forItemID id: String) {
        cards[id]?.setFavorite(isFavorite)
    }

    func setLoadingMore(_ isLoading: Bool) {
        showMoreButton.isEnabled = !isLoading
        showMoreButton.alpha = isLoading ? 0.6 : 1
    }

    private func setupUI() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = AppColor.PrimaryColors.Gray.color200
        separator.snp.makeConstraints { make in
            make.height.equalTo(Layout.separatorHeight)
        }
        return separator
    }

    @objc private func cardTapped(_ recognizer: UITapGestureRecognizer) {
        guard let id = (recognizer.view as? TourCardView)?.itemID else { return }
        onSelectItem?(id)
    }

    @objc private func showMoreTapped() {
        onShowMore?()
    }
}

extension TourSectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIControl)
    }
}
