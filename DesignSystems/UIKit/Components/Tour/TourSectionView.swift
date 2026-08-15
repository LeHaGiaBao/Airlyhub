//
//  TourSectionView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// A titled list of tour cards with a "Show more" button underneath — the
/// "Air tours" block on Explore and the "Search results" block on Flights.
///
/// Cards go in a stack view rather than a table: the section is meant to sit inside
/// the screen's own scroll view, and a nested scrolling table there would fight the
/// parent for gestures and lose its self-sizing. Paging appends three cards at a
/// time, so the view count stays small enough that recycling buys nothing.
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

    /// Cards in display order, so `setFavorite` can reach one without a re-render.
    private var cards: [String: TourCardView] = [:]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.applyTypography(.textXl(weight: .bold))
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

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, cardsStack, emptyLabel, showMoreButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.setCustomSpacing(Layout.titleSpacing, after: titleLabel)
        stack.setCustomSpacing(Layout.buttonSpacing, after: cardsStack)
        stack.setCustomSpacing(Layout.buttonSpacing, after: emptyLabel)
        return stack
    }()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
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
        set { titleLabel.text = newValue }
    }

    // MARK: - Content

    /// Replaces the list — a fresh search.
    func configure(with items: [TourCardModel], hasMore: Bool) {
        clear()
        append(items, hasMore: hasMore)
    }

    /// Empties the list while a search runs.
    ///
    /// Distinct from `configure(with: [], …)`, which would surface the "no matches"
    /// message — the right thing once a search has answered, and misleading while
    /// one is still in flight.
    func setLoading() {
        clear()
        emptyLabel.isHidden = true
        showMoreButton.isHidden = true
    }

    private func clear() {
        cards.removeAll()
        cardsStack.arrangedSubviews.forEach {
            cardsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    /// Adds the next page underneath what is already there — "Show more".
    func append(_ items: [TourCardModel], hasMore: Bool) {
        for item in items {
            // A separator sits above every card except the first, matching the
            // hairline between results in the design.
            if !cardsStack.arrangedSubviews.isEmpty {
                cardsStack.addArrangedSubview(makeSeparator())
            }

            let card = TourCardView()
            card.configure(with: item)
            card.onToggleFavorite = { [weak self] id in
                self?.onToggleFavorite?(id)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
            // Without a delegate the card's tap also fires when the heart is
            // pressed, so a favourite would open the detail screen behind it.
            tap.delegate = self
            card.addGestureRecognizer(tap)
            cards[item.id] = card
            cardsStack.addArrangedSubview(card)
        }

        emptyLabel.isHidden = !cards.isEmpty
        showMoreButton.isHidden = !hasMore
    }

    /// Flips one heart without rebuilding the list.
    func setFavorite(_ isFavorite: Bool, forItemID id: String) {
        cards[id]?.setFavorite(isFavorite)
    }

    /// Blocks a second tap while the next page is in flight.
    func setLoadingMore(_ isLoading: Bool) {
        showMoreButton.isEnabled = !isLoading
        showMoreButton.alpha = isLoading ? 0.6 : 1
    }

    // MARK: - Setup

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

// MARK: - UIGestureRecognizerDelegate
extension TourSectionView: UIGestureRecognizerDelegate {
    /// Lets any control inside a card — today just the favourite button — handle its
    /// own touch instead of the card swallowing it.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIControl)
    }
}
