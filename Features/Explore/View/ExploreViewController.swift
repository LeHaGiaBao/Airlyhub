//
//  ExploreViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class ExploreViewController: BaseViewController {
    var presenter: ExplorePresenterProtocol!

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let searchView = UIView()

    private lazy var locationView = ExploreLocationRowView()

    private lazy var dateView: FlightsDateRowView = {
        let view = FlightsDateRowView()
        view.placeholder = NSLocalizedString("select_date", comment: "")
        view.datePickerMode = .date
        view.delegate = self
        return view
    }()

    private let passenger = FlightsPassengersRowView()

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
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupSearchView()
    }
}

extension ExploreViewController: ExploreViewProtocol {
    private func setupSearchView() {
        view.addSubview(searchView)
        searchView.backgroundColor = .white
        
        setupTitle()
        setupSubTitle()
        
        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20)),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(20))
        ])
    }
    
    private func setupTitle() {
        titleLabel.text = NSLocalizedString("extreme", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColor.PrimaryColors.Primary.color500
        titleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(98)),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
    }
    
    private func setupSubTitle() {
        subTitleLabel.text = NSLocalizedString("airplane_flight", comment: "")
        subTitleLabel.textAlignment = .left
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textColor = AppColor.PrimaryColors.Gray.color700
        subTitleLabel.applyTypography(.displaySm(weight: .bold))

        searchView.addSubview(subTitleLabel)

        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(4)),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])

        setupFindTourView()
    }

    private func setupFindTourView() {
        view.addSubview(locationView)
        view.addSubview(dateView)
        view.addSubview(passenger)
        view.addSubview(findTourButton)

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
}

extension ExploreViewController {
    private func setupLocationEvents() {
        locationView.onLocationTap = { [weak self] in
            self?.presentLocationFinder()
        }
    }

    private func presentLocationFinder() {
        let picker = LocationFinder()
        picker.modalPresentationStyle = .overFullScreen
        picker.modalTransitionStyle = .crossDissolve

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
