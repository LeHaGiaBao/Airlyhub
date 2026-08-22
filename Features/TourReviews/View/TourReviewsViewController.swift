//
//  TourReviewsViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// "All reviews": a plain scrolling list of the same `TourReviewCardView` the
/// detail screen shows, each wrapped in its own white card.
///
/// A scroll view holding a stack, not a table — the same call
/// `SearchResultsViewController` makes for its own list, and for the same reason:
/// nothing here is paged or recycled, so a table's reuse machinery would cost more
/// than it saves.
final class TourReviewsViewController: BaseViewController {
    var presenter: TourReviewsPresenterProtocol!

    private enum Layout {
        static let navigatorHeight: CGFloat = 56
        static let contentTop: CGFloat = 16
        static let contentBottom: CGFloat = 24
        static let cardSpacing: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 12
    }

    private let topNavigatorVC = TopNavigatorView(
        topNavigatorTile: NSLocalizedString("tour_detail_customer_reviews", comment: "")
    )

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.cardSpacing
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedTopNavigator()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Layout.navigatorHeight)
            make.left.right.bottom.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            // Vertical range comes from the content guide, so the stack can grow
            // past one screen; horizontal comes from the frame guide instead of
            // the content guide, since the content guide has no width of its own
            // to inset from — pinning both there would leave the scroll view
            // guessing which one to satisfy first.
            make.top.equalTo(scrollView.contentLayoutGuide).offset(Layout.contentTop)
            make.bottom.equalTo(scrollView.contentLayoutGuide).offset(-Layout.contentBottom)
            make.left.right.equalTo(scrollView.frameLayoutGuide).inset(Devices.paddingHorizontal)
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

    /// Same shadow recipe `FlightsDateRowView` and `ExploreLocationRowView` use for
    /// their own cards, so a review card reads as the same surface as the rest of
    /// the app rather than introducing a new elevation style.
    private func makeCard(containing content: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = Layout.cardCornerRadius
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 12

        card.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.cardPadding)
        }

        return card
    }
}

// MARK: - TourReviewsViewProtocol
extension TourReviewsViewController: TourReviewsViewProtocol {
    func showReviews(_ reviews: [TourReviewModel]) {
        contentStack.arrangedSubviews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        reviews.forEach { review in
            let reviewCard = TourReviewCardView()
            reviewCard.configure(with: review)
            contentStack.addArrangedSubview(makeCard(containing: reviewCard))
        }
    }
}
