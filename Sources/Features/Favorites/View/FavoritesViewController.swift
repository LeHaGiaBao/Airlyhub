//
//  FavoritesViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit
import SnapKit

/// Saved tours and flights: a title, the two pills, and one list under them.
final class FavoritesViewController: BaseViewController {
    var presenter: FavoritesPresenterProtocol!

    private enum Layout {
        static let titleTop: CGFloat = 98
        static let tabsTop: CGFloat = 24
        static let listTop: CGFloat = 24
        static let listBottom: CGFloat = 24
        static let loadingTop: CGFloat = 40
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("favorites", comment: "")
        label.textColor = AppColor.PrimaryColors.Gray.color700
        label.applyTypography(.displaySm(weight: .bold))
        return label
    }()

    private let tabsContainer = UIView()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    private let listView = TourSectionView(frame: .zero)

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
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(tabsContainer)
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(listView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.titleTop)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        tabsContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.tabsTop)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(tabsContainer.snp.bottom).offset(Layout.listTop)
            make.left.right.bottom.equalToSuperview()
        }

        listView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(Layout.listBottom)
            make.left.right.equalTo(scrollView.contentLayoutGuide).inset(Devices.paddingHorizontal)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-Devices.paddingHorizontal * 2)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView).offset(Layout.loadingTop)
        }
    }

    private func setupEvents() {
        listView.onSelectItem = { [weak self] id in
            self?.presenter.didSelectItem(id: id)
        }

        listView.onToggleFavorite = { [weak self] id in
            FeedbackGenerator.onFeedbackGenerator(.soft)
            self?.presenter.didRemoveFavorite(id: id)
        }
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func showTabs(titles: [String], selectedIndex: Int) {
        let tabsView = SegmentedPillView(titles: titles, selectedIndex: selectedIndex)
        tabsView.onSelect = { [weak self] index in
            self?.presenter.didSelectTab(at: index)
        }

        tabsContainer.addSubview(tabsView)
        tabsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            listView.setLoading()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showItems(_ items: [TourCardModel], emptyMessage: String) {
        listView.emptyMessage = emptyMessage
        listView.configure(with: items, hasMore: false)
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}
