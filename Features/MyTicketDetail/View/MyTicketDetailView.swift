//
//  MyTicketDetailView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// One booked ticket: the reference as the title, the price tag hooked over the top
/// of the stub, and the stub itself.
final class MyTicketDetailView: BaseViewController {
    var presenter: MyTicketDetailPresenterProtocol!

    private enum Layout {
        static let navigatorHeight: CGFloat = 56
        static let cardTop: CGFloat = 32
        static let cardBottom: CGFloat = 32
    }

    /// Built with an empty title and filled from the record, so the header cannot
    /// show a reference the card disagrees with.
    private let topNavigatorVC = TopNavigatorView(topNavigatorTile: "")

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    private let contentView = UIView()
    private let ticketCard = TicketCardView()
    private let priceBadge = PriceBadgeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedTopNavigator()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(ticketCard)
        // Added after the card so it sits over the stub's top edge, the way a tag
        // is hooked onto a real ticket.
        contentView.addSubview(priceBadge)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Layout.navigatorHeight)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            // A vertical scroll view gives its content no width of its own; without
            // this the card would collapse to nothing.
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        ticketCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.cardTop)
            make.left.right.equalToSuperview().inset(Devices.paddingHorizontal)
            make.bottom.equalToSuperview().inset(Layout.cardBottom)
        }

        priceBadge.snp.makeConstraints { make in
            make.centerX.equalTo(ticketCard)
            // Straddles the edge: half the tag hangs above the card, which is why
            // `cardTop` leaves room over it.
            make.centerY.equalTo(ticketCard.snp.top)
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
}

// MARK: - MyTicketDetailViewProtocol
extension MyTicketDetailView: MyTicketDetailViewProtocol {
    func showTicket(_ ticket: TicketModel) {
        topNavigatorVC.topNavigatorTile = ticket.id
        priceBadge.text = ticket.priceText
        ticketCard.configure(with: ticket)
    }
}
