//
//  ExploreViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ExploreViewController: BaseViewController {
    var presenter: ExplorePresenterProtocol!

    private enum Layout {
        static let searchCornerRadius: CGFloat = 20
        static let searchBottomPadding: CGFloat = 24
        static let panelSpacing: CGFloat = 12
    }

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Layout.searchCornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = false
        return view
    }()

    private lazy var locationView = ExploreLocationRowView()

    private lazy var dateView: FlightsDateRowView = {
        let view = FlightsDateRowView()
        view.placeholder = NSLocalizedString("select_date", comment: "")
        view.datePickerMode = .date
        view.delegate = self
        return view
    }()

    private let passenger = FlightsPassengersRowView()

    private let helpfulInformationView = HelpfulInformationSectionView()

    private let findTourButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("find_tour", comment: ""), for: .normal)
        button.applyButtonStyle(.defaultButton(size: .big))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationEvents()
        findTourButton.addTarget(self, action: #selector(findTourTapped), for: .touchUpInside)
        presenter.viewDidLoad()
    }

    @objc private func findTourTapped() {
        FeedbackGenerator.onFeedbackGenerator(.soft)
        presenter.didTapFindTour(
            location: locationView.location,
            date: dateView.selectedDate,
            passengers: passenger.count
        )
    }

    private func setupUI() {
        setupSearchView()
        setupHelpfulInformationView()
    }
}

extension ExploreViewController: ExploreViewProtocol {
    func showHelpfulInformation(_ items: [HelpfulInformationItem]) {
        helpfulInformationView.configure(with: items)
    }

    func showError(_ message: String) {
        ToastView.show(message, style: .info, in: view)
    }

    private func setupSearchView() {
        view.addSubview(searchView)

        setupTitle()
        setupSubTitle()

        searchView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(findTourButton.snp.bottom).offset(Layout.searchBottomPadding)
        }
    }

    private func setupTitle() {
        titleLabel.text = NSLocalizedString("extreme", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColor.PrimaryColors.Primary.color500
        titleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98)
            make.left.equalToSuperview().offset(20)
        }
    }

    private func setupSubTitle() {
        subTitleLabel.text = NSLocalizedString("airplane_flight", comment: "")
        subTitleLabel.textAlignment = .left
        subTitleLabel.textColor = AppColor.PrimaryColors.Gray.color700
        subTitleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(subTitleLabel)

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }

        setupFindTourView()
    }

    private func setupFindTourView() {
        searchView.addSubview(locationView)
        searchView.addSubview(dateView)
        searchView.addSubview(passenger)
        searchView.addSubview(findTourButton)

        locationView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(12)
        }

        dateView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }

        passenger.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }

        findTourButton.snp.makeConstraints { make in
            make.top.equalTo(passenger.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }
    }

    private func setupHelpfulInformationView() {
        view.addSubview(helpfulInformationView)

        helpfulInformationView.onSelectItem = { [weak self] item in
            self?.presenter.didSelectHelpfulInformation(item)
        }

        helpfulInformationView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(Layout.panelSpacing)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ExploreViewController {
    private func setupLocationEvents() {
        locationView.onLocationTap = { [weak self] in
            self?.presentLocationFinder()
        }
    }

    private func presentLocationFinder() {
        let picker = LocationFinder()
        picker.onConfirm = { [weak self] location in
            self?.locationView.setLocation(location)
        }

        present(picker, animated: true)
    }
}

extension ExploreViewController: FlightsDateRowViewDelegate {
    func dateInputView(_ view: FlightsDateRowView, didSelectDate date: Date) {
    }

    func dateInputViewDidTap(_ view: FlightsDateRowView) {
    }

    func dateInputViewDidCancel(_ view: FlightsDateRowView) {
    }
}
