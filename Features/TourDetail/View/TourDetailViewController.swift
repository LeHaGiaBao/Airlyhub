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
///
/// One screen, not two: every section below the hero photo either renders from
/// `TourDetailViewModel` or hides itself when that model leaves the section empty
/// — the duration row for a flight, the description for either, the origin-or-date
/// row choosing between a static label and `FlightsDateRowView`. See
/// `TourDetailViewModel` for where each of those decisions is made; this file only
/// asks "is there something to show here".
///
/// The body is a column of white cards over the app's grey background rather than
/// one continuous white sheet — the grey gap between cards is what groups the
/// parameters, the flight setup, the pilot and the reviews into four things a
/// reader scans separately.
final class TourDetailViewController: BaseViewController {
    var presenter: TourDetailPresenterProtocol!

    private enum Layout {
        static let heroHeight: CGFloat = 240
        static let cardPadding: CGFloat = 20
        static let cardCornerRadius: CGFloat = 16
        /// The grey seam between two cards.
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
        // `.automatic` pads the content by the safe area even though the scroll
        // view's own frame already starts at `view.top` — without this the hero
        // photo sits a status-bar's-height below the top edge instead of bleeding
        // under it.
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

    /// The photo and the copy under it are one card, not a card following a photo:
    /// the title reads as this photo's caption, and the first grey seam belongs
    /// below the description rather than between them.
    ///
    /// Built by hand instead of through `makeCard` because the photo has to bleed
    /// past the padding the copy sits inside, and because only three of the four
    /// corners are rounded — the top two run off the top of the screen, under the
    /// status bar.
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

        // The photo rounds off its own bottom corners, and the white card behind it
        // is what shows through them — which is only true because the two share a
        // surface. Rounding the card's top corners instead would cut the page's
        // grey into the seam.
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

    /// Duration, departure time and route share one card: they are the three knobs
    /// that decide which flight is being booked, and the design keeps them on a
    /// single surface for that reason.
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

    /// Plain `UIButton()`, not `.system`: `applyButtonStyle` paints every state
    /// through a `UIButton.Configuration`, and a system button adds its own
    /// tint-based dimming that fights it.
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

    /// Sits on the page's grey rather than on a raised white bar — the cards above
    /// already end in grey, so a white footer would read as a sixth card.
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

    /// The photo runs under the status bar, and it is dark at the top on every
    /// record — the clock has to be light to stay legible over it.
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

        // Runs edge to edge, ignoring the safe area, so the hero photo bleeds under
        // the status bar the way the design shows it — the back and favourite
        // buttons pin to their own safe-area guide inside `TourHeroHeaderView`
        // instead, which is what keeps them clear of the notch.
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

    // MARK: - Section helpers

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

    /// A full-bleed white card. Deliberately unclipped so `makeBleedingRow` can let
    /// a pill row overflow the trailing padding.
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

    /// Lets a horizontally scrolling row run past the card's trailing padding to
    /// the screen edge. The design cuts the duration row off mid-pill at the edge,
    /// which is the cue that it scrolls; stopping it at the padding would instead
    /// read as a row that simply ends there.
    private func makeBleedingRow(_ content: UIView) -> UIView {
        let container = UIView()
        container.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().offset(Layout.cardPadding)
        }
        return container
    }

    /// Same shadow recipe `TourReviewsViewController` gives its own review cards,
    /// so one review looks identical whether it is read here or on the full list.
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

// MARK: - TourDetailViewProtocol
extension TourDetailViewController: TourDetailViewProtocol {
    func showLoading(_ isLoading: Bool) {
        scrollView.isHidden = isLoading
        footerView.isHidden = isLoading
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
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

        // Written into the configuration, not via `setTitle(_:for:)`: a legacy
        // title is only folded into a configuration at the moment one is assigned,
        // so setting it afterwards — as this does, on every render — leaves the
        // button blank. `applyButtonStyle` has already installed the configuration
        // by the time this runs.
        bookButton.configuration?.title = viewModel.bookButtonText
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}
