//
//  SearchResultsViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Results for both searches: header, an optional "Popular" rail, then the list.
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

    private lazy var popularPanel = makePanel(
        containing: popularView,
        corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    )
    private lazy var popularView = TourCarouselView(title: NSLocalizedString("popular", comment: ""))

    private let resultsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var resultsPanel = makePanel(
        containing: resultsView,
        corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    )
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
        scrollView.addSubview(resultsBackground)
        scrollView.addSubview(contentStack)
        view.addSubview(loadingIndicator)

        contentStack.addArrangedSubview(popularPanel)
        contentStack.addArrangedSubview(resultsPanel)
        popularPanel.isHidden = true

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
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }

        resultsBackground.snp.makeConstraints { make in
            make.top.equalTo(resultsPanel.snp.top).offset(Layout.cornerRadius)
            make.left.right.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }

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
            make.bottom.lessThanOrEqualToSuperview().inset(Layout.panelPadding)
            make.bottom.equalToSuperview().inset(Layout.panelPadding).priority(.high)
        }

        return panel
    }

    private func applyHeaderMerge(popularVisible: Bool) {
        headerPanel.layer.cornerRadius = popularVisible ? 0 : Layout.cornerRadius
        scrollView.snp.updateConstraints { make in
            make.top.equalTo(headerPanel.snp.bottom).offset(popularVisible ? 0 : Layout.panelSpacing)
        }
    }
}

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
        popularPanel.isHidden = items.isEmpty
        applyHeaderMerge(popularVisible: !items.isEmpty)
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
