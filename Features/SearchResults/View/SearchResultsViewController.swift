//
//  SearchResultsViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Results for both searches: header, an optional "Popular" rail, then the list.
///
/// A scroll view holding a stack, rather than a table with sections. The rail and
/// the list are different enough in layout that expressing them as one table's
/// sections would cost more than it saves, and "Show more" appends three cards at a
/// time — never enough on screen for recycling to matter.
final class SearchResultsViewController: BaseViewController {
    var presenter: SearchResultsPresenterProtocol!

    private enum Layout {
        static let headerTop: CGFloat = 12
        static let headerBottom: CGFloat = 20
        static let panelSpacing: CGFloat = 12
        static let panelPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }

    private let headerView = SearchSummaryHeaderView()

    /// White zone behind the search bar, running up under the status bar and rounded
    /// on its lower edge — the same treatment `ExploreViewController` gives its own
    /// search panel, so the two screens read as one surface when you navigate.
    private let headerPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()

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
        stack.spacing = Layout.panelSpacing
        return stack
    }()

    private lazy var popularPanel = makePanel(containing: popularView)
    private lazy var popularView = TourCarouselView(title: NSLocalizedString("popular", comment: ""))

    /// Only the top corners are rounded: this panel always reaches the bottom of the
    /// screen, so rounding its lower edge would cut a notch out of the surface.
    private lazy var resultsPanel = makePanel(
        containing: resultsView,
        corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    )
    /// Title comes from the context in `showHeader`, so it is built without one.
    private let resultsView = TourSectionView(frame: .zero)

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(headerPanel)
        headerPanel.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(loadingIndicator)

        contentStack.addArrangedSubview(popularPanel)
        contentStack.addArrangedSubview(resultsPanel)
        // Revealed by `showPopular` once there is something to show. Flights never
        // calls it, and Explore only after the rail has loaded — either way the
        // screen never renders a titled panel with nothing under it.
        popularPanel.isHidden = true

        // Pinned to `view.top`, not the safe area, so the white runs behind the
        // status bar rather than leaving a grey strip above it.
        headerPanel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(headerView.snp.bottom).offset(Layout.headerBottom)
        }

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Layout.headerTop)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerPanel.snp.bottom).offset(Layout.panelSpacing)
            make.left.right.bottom.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            // Pins the stack to the viewport's width; without it a vertical stack in
            // a scroll view has no defined width and collapses.
            make.width.equalTo(scrollView.frameLayoutGuide)
            // Short results still fill the screen. Combined with the low hugging
            // priority below, the leftover height goes to the results panel, so the
            // white surface reaches the bottom edge instead of stopping mid-screen
            // and leaving a grey band under it.
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }

        // Lowest hugging in the stack, so it is the panel that absorbs the slack.
        resultsPanel.setContentHuggingPriority(.defaultLow - 1, for: .vertical)

        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView).offset(Layout.panelPadding * 3)
        }
    }

    private func setupEvents() {
        headerView.onBack = { [weak self] in
            self?.presenter.didTapBack()
        }

        headerView.onFilter = { [weak self] in
            self?.presenter.didTapFilter()
        }

        resultsView.onSelectItem = { [weak self] id in
            self?.presenter.didSelectItem(id: id)
        }

        resultsView.onToggleFavorite = { [weak self] id in
            self?.presenter.didToggleFavorite(id: id)
        }

        resultsView.onShowMore = { [weak self] in
            self?.presenter.didTapShowMore()
        }

        popularView.onSelectItem = { [weak self] id in
            self?.presenter.didSelectItem(id: id)
        }
    }

    /// Wraps a section in the white rounded panel the design uses to separate blocks.
    ///
    /// - Parameter corners: defaults to all four.
    private func makePanel(containing content: UIView,
                           corners: CACornerMask = [
                            .layerMinXMinYCorner, .layerMaxXMinYCorner,
                            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
                           ]) -> UIView {
        let panel = UIView()
        panel.backgroundColor = .white
        panel.layer.cornerRadius = Layout.cornerRadius
        panel.layer.maskedCorners = corners
        panel.addSubview(content)

        content.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Layout.panelPadding)
            // The bottom is two constraints rather than one so the panel can be
            // stretched taller than its content without dragging the content with
            // it — a plain equality here would pull the cards apart when the
            // results panel expands to fill the screen. The required inequality
            // keeps the padding; the optional equality sizes the panel when there
            // is no slack to absorb.
            make.bottom.lessThanOrEqualToSuperview().inset(Layout.panelPadding)
            make.bottom.equalToSuperview().inset(Layout.panelPadding).priority(.high)
        }

        return panel
    }
}

// MARK: - SearchResultsViewProtocol
extension SearchResultsViewController: SearchResultsViewProtocol {
    func showHeader(summary: String, sectionTitle: String) {
        headerView.summary = summary
        resultsView.title = sectionTitle
    }

    func updateSummary(_ summary: String) {
        headerView.summary = summary
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            // The panel stays visible and keeps filling the screen. Hiding it would
            // leave the "Popular" rail as the only thing in the stack, and the
            // stretch meant for the results would blow that panel up to full height.
            resultsView.setLoading()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showResults(_ items: [TourCardModel], hasMore: Bool) {
        resultsView.configure(with: items, hasMore: hasMore)
    }

    func appendResults(_ items: [TourCardModel], hasMore: Bool) {
        resultsView.append(items, hasMore: hasMore)
    }

    func showPopular(_ items: [TourCardModel]) {
        // An empty rail would leave a titled panel with nothing under it.
        popularPanel.isHidden = items.isEmpty
        popularView.configure(with: items)
    }

    func setFavorite(_ isFavorite: Bool, forItemID id: String) {
        resultsView.setFavorite(isFavorite, forItemID: id)
    }

    func setLoadingMore(_ isLoading: Bool) {
        resultsView.setLoadingMore(isLoading)
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}
