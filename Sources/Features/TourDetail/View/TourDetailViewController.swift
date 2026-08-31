//
//  TourDetailViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 22/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// Detail screen for both an air tour and a point-to-point flight.
final class TourDetailViewController: BaseViewController {
    var presenter: TourDetailPresenterProtocol!

    private enum Layout {
        static let heroHeight: CGFloat = 240
        static let cardPadding: CGFloat = 20
        static let cardCornerRadius: CGFloat = 16
        static let cardSpacing: CGFloat = 8
        static let sectionSpacing: CGFloat = 24
        static let rowSpacing: CGFloat = 12
        static let overviewSpacing: CGFloat = 16
        static let routeSpacing: CGFloat = 16
        static let reviewSpacing: CGFloat = 12
        static let reviewCardPadding: CGFloat = 16
        static let reviewCardCornerRadius: CGFloat = 12
        static let footerPadding: CGFloat = 20
        static let footerTermsSpacing: CGFloat = 12
        static let airfieldRowHeight: CGFloat = 48
        static let iconSize: CGFloat = 24
    }

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()

    private let sectionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.cardSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: Layout.cardSpacing, trailing: 0
        )
        return stack
    }()

    private let heroHeader = TourHeroHeaderView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textLg(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color600
        label.numberOfLines = 0
        return label
    }()

    private lazy var overviewCard: UIView = {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = Layout.cardCornerRadius
        card.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.spacing = Layout.overviewSpacing

        card.addSubview(heroHeader)
        card.addSubview(textStack)

        heroHeader.bottomCornerRadius = Layout.cardCornerRadius

        heroHeader.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Layout.heroHeight)
        }
        textStack.snp.makeConstraints { make in
            make.top.equalTo(heroHeader.snp.bottom).offset(Layout.cardPadding)
            make.left.right.bottom.equalToSuperview().inset(Layout.cardPadding)
        }
        return card
    }()

    private let parametersCard = TourParametersCardView()
    private lazy var parametersCardContainer = makeCard(
        containing: makeSection(
            title: NSLocalizedString("tour_detail_parameters", comment: ""),
            content: parametersCard
        )
    )

    private let durationPillRow = PillSelectorScrollView()
    private lazy var durationSection = makeSection(
        title: NSLocalizedString("tour_detail_flight_duration", comment: ""),
        content: makeBleedingRow(durationPillRow)
    )

    private let departureTitleLabel = TourDetailViewController.makeSectionTitleLabel(text: "")
    private let departurePillRow = PillSelectorScrollView()
    private lazy var departureSection = makeSection(
        titleLabel: departureTitleLabel,
        content: makeBleedingRow(departurePillRow)
    )

    private let airfieldIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsIcon.mapFlight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let airfieldLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textMd(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private lazy var airfieldRow: UIView = {
        let row = UIView()
        row.backgroundColor = AppColor.PrimaryColors.Gray.color50
        row.layer.cornerRadius = 8
        row.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [airfieldIcon, airfieldLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12

        row.addSubview(stack)
        airfieldIcon.snp.makeConstraints { make in
            make.width.height.equalTo(Layout.iconSize)
        }
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        row.snp.makeConstraints { make in
            make.height.equalTo(Layout.airfieldRowHeight)
        }
        return row
    }()

    private let routeTimeline = RouteTimelineView()

    private lazy var routeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [airfieldRow, routeTimeline])
        stack.axis = .vertical
        stack.spacing = Layout.routeSpacing
        return stack
    }()

    private lazy var routeSection = makeSection(
        title: NSLocalizedString("tour_detail_flight_route", comment: ""),
        content: routeStack
    )

    private lazy var flightCard = makeCard(containing: {
        let stack = UIStackView(arrangedSubviews: [durationSection, departureSection, routeSection])
        stack.axis = .vertical
        stack.spacing = Layout.sectionSpacing
        return stack
    }())

    private let pilotCard = PilotInfoCardView()
    private lazy var pilotCardContainer = makeCard(
        containing: makeSection(
            title: NSLocalizedString("tour_detail_pilot_information", comment: ""),
            content: pilotCard
        )
    )

    private let reviewsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.reviewSpacing
        return stack
    }()

    private lazy var allReviewsButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("tour_detail_all_reviews", comment: ""), for: .normal)
        button.applyButtonStyle(.outlinedButton(size: .middle))
        return button
    }()

    private lazy var reviewsCardContainer = makeCard(
        containing: makeSection(
            title: NSLocalizedString("tour_detail_customer_reviews", comment: ""),
            content: {
                let stack = UIStackView(arrangedSubviews: [reviewsStack, allReviewsButton])
                stack.axis = .vertical
                stack.spacing = Layout.reviewCardPadding
                return stack
            }()
        )
    )

    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.BaseColor.backgroundColor
        return view
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tour_detail_terms_notice", comment: "")
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Primary.color500
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookButton: UIButton = {
        let button = UIButton()
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(sectionsStack)
        view.addSubview(footerView)
        view.addSubview(loadingIndicator)

        [overviewCard, parametersCardContainer, flightCard, pilotCardContainer, reviewsCardContainer]
            .forEach(sectionsStack.addArrangedSubview)

        heroHeader.stretchImage(alongside: scrollView)

        footerView.addSubview(termsLabel)
        footerView.addSubview(bookButton)

        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }

        sectionsStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

        termsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.footerPadding)
            make.left.right.equalToSuperview().inset(Layout.footerPadding)
        }

        bookButton.snp.makeConstraints { make in
            make.top.equalTo(termsLabel.snp.bottom).offset(Layout.footerTermsSpacing)
            make.left.right.equalToSuperview().inset(Layout.footerPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.footerPadding)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupEvents() {
        heroHeader.onBack = { [weak self] in
            self?.presenter.didTapBack()
        }
        heroHeader.onToggleFavorite = { [weak self] in
            self?.presenter.didToggleFavorite()
        }

        parametersCard.onDateSelected = { [weak self] date in
            self?.presenter.didSelectDate(date)
        }
        parametersCard.onPassengersChange = { [weak self] count in
            self?.presenter.didChangePassengers(count)
        }

        durationPillRow.onSelect = { [weak self] index in
            self?.presenter.didSelectDuration(index: index)
        }
        departurePillRow.onSelect = { [weak self] index in
            self?.presenter.didSelectDepartureTime(index: index)
        }

        allReviewsButton.addTarget(self, action: #selector(allReviewsTapped), for: .touchUpInside)
        bookButton.addTarget(self, action: #selector(bookTapped), for: .touchUpInside)
    }

    @objc private func allReviewsTapped() {
        presenter.didTapAllReviews()
    }

    @objc private func bookTapped() {
        presenter.didTapBook()
    }

    private func makeSection(title: String, content: UIView) -> UIStackView {
        makeSection(titleLabel: Self.makeSectionTitleLabel(text: title), content: content)
    }

    private func makeSection(titleLabel: UILabel, content: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, content])
        stack.axis = .vertical
        stack.spacing = Layout.rowSpacing
        return stack
    }

    private static func makeSectionTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.applyTypography(.textLg(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }

    private func makeCard(containing content: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = Layout.cardCornerRadius
        card.clipsToBounds = false

        card.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.cardPadding)
        }
        return card
    }

    private func makeBleedingRow(_ content: UIView) -> UIView {
        let container = UIView()
        container.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().offset(Layout.cardPadding)
        }
        return container
    }

    private func makeReviewCard(containing content: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = Layout.reviewCardCornerRadius
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 12

        card.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Layout.reviewCardPadding)
        }
        return card
    }
}

extension TourDetailViewController: TourDetailViewProtocol {
    func showLoading(_ isLoading: Bool) {
        scrollView.isHidden = isLoading
        footerView.isHidden = isLoading
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func render(_ viewModel: TourDetailViewModel) {
        heroHeader.configure(
            imageURL: viewModel.imageURL,
            ratingText: viewModel.ratingText,
            badges: viewModel.heroBadges,
            isFavorite: viewModel.isFavorite
        )

        titleLabel.setText(viewModel.title)
        descriptionLabel.setText(viewModel.description)
        descriptionLabel.isHidden = viewModel.description == nil

        parametersCard.configure(with: viewModel)

        durationSection.isHidden = viewModel.durationTitles.isEmpty
        durationPillRow.configure(titles: viewModel.durationTitles, selectedIndex: viewModel.selectedDurationIndex)

        departureTitleLabel.setText(viewModel.departureSectionTitle)
        departurePillRow.configure(
            titles: viewModel.departureTimeTitles,
            selectedIndex: viewModel.selectedDepartureTimeIndex
        )

        airfieldLabel.setText(viewModel.airfieldText)
        airfieldRow.isHidden = viewModel.airfieldText == nil
        routeTimeline.configure(waypoints: viewModel.routeWaypoints)

        pilotCard.configure(with: viewModel.pilot)

        reviewsStack.arrangedSubviews.forEach {
            reviewsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        viewModel.reviews.forEach {
            let card = TourReviewCardView()
            card.configure(with: $0)
            reviewsStack.addArrangedSubview(makeReviewCard(containing: card))
        }
        reviewsCardContainer.isHidden = viewModel.reviews.isEmpty

        bookButton.configuration?.title = viewModel.bookButtonText
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}
