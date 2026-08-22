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
final class TourDetailViewController: BaseViewController {
    var presenter: TourDetailPresenterProtocol!

    private enum Layout {
        static let heroHeight: CGFloat = 320
        static let bodyPadding: CGFloat = 20
        static let bodyTopRadius: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let rowSpacing: CGFloat = 12
        static let footerPadding: CGFloat = 20
        static let footerTermsSpacing: CGFloat = 12
        static let airfieldRowHeight: CGFloat = 48
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

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()

    private let heroHeader = TourHeroHeaderView()

    private let bodyContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.bodyTopRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textXl(weight: .semibold))
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

    private let parametersCard = TourParametersCardView()

    private let durationPillRow = PillSelectorScrollView()
    private lazy var durationSection = makeSection(
        title: NSLocalizedString("tour_detail_flight_duration", comment: ""),
        content: durationPillRow
    )

    private let departureTitleLabel = TourDetailViewController.makeSectionTitleLabel(text: "")
    private let departurePillRow = PillSelectorScrollView()
    private lazy var departureSection = makeSection(titleLabel: departureTitleLabel, content: departurePillRow)

    private let airfieldIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsIcon.location
        imageView.contentMode = .left
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private let airfieldLabel: UILabel = {
        let label = UILabel()
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
    }()

    private lazy var airfieldRow: UIView = {
        let row = UIView()
        row.backgroundColor = AppColor.PrimaryColors.Gray.color25
        row.layer.cornerRadius = 8
        row.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [airfieldIcon, airfieldLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12

        row.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
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
        stack.spacing = Layout.rowSpacing
        return stack
    }()

    private lazy var routeSection = makeSection(
        title: NSLocalizedString("tour_detail_flight_route", comment: ""),
        content: routeStack
    )

    private let pilotCard = PilotInfoCardView()
    private lazy var pilotSection = makeSection(
        title: NSLocalizedString("tour_detail_pilot_information", comment: ""),
        content: pilotCard
    )

    private let reviewsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.sectionSpacing
        return stack
    }()

    private lazy var allReviewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("tour_detail_all_reviews", comment: ""), for: .normal)
        button.applyButtonStyle(.outlinedButton(size: .middle))
        return button
    }()

    private lazy var reviewsSection = makeSection(
        title: NSLocalizedString("tour_detail_customer_reviews", comment: ""),
        content: {
            let stack = UIStackView(arrangedSubviews: [reviewsStack, allReviewsButton])
            stack.axis = .vertical
            stack.spacing = Layout.sectionSpacing
            return stack
        }()
    )

    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        return view
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tour_detail_terms_notice", comment: "")
        label.applyTypography(.textXs(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(footerView)
        view.addSubview(loadingIndicator)

        contentStack.addArrangedSubview(heroHeader)
        contentStack.addArrangedSubview(bodyContainer)

        let bodyStack = UIStackView(arrangedSubviews: [
            titleLabel, descriptionLabel, parametersCard,
            durationSection, departureSection, routeSection, pilotSection, reviewsSection
        ])
        bodyStack.axis = .vertical
        bodyStack.alignment = .fill
        bodyStack.spacing = Layout.sectionSpacing
        bodyContainer.addSubview(bodyStack)

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

        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        heroHeader.snp.makeConstraints { make in
            make.height.equalTo(Layout.heroHeight)
        }

        bodyStack.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Layout.bodyPadding)
            make.bottom.equalToSuperview().inset(Layout.bodyPadding)
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
        label.applyTypography(.textMd(weight: .semibold))
        label.textColor = AppColor.PrimaryColors.Gray.color800
        return label
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

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description == nil

        parametersCard.configure(with: viewModel)

        durationSection.isHidden = viewModel.durationTitles.isEmpty
        durationPillRow.configure(titles: viewModel.durationTitles, selectedIndex: viewModel.selectedDurationIndex)

        departureTitleLabel.text = viewModel.departureSectionTitle
        departurePillRow.configure(
            titles: viewModel.departureTimeTitles,
            selectedIndex: viewModel.selectedDepartureTimeIndex
        )

        airfieldLabel.text = viewModel.airfieldText
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
            reviewsStack.addArrangedSubview(card)
        }

        bookButton.setTitle(viewModel.bookButtonText, for: .normal)
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .error, in: view)
    }
}
