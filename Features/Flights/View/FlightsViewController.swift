//
//  FlightsViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import UIKit

final class FlightsViewController: BaseViewController {
    var presenter: FlightsPresenterProtocol!
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private lazy var flightsLocationView = FlightsLocationRowView()

    private lazy var departureView: FlightsDateRowView = {
        let view = FlightsDateRowView()
        view.placeholder = NSLocalizedString("flights_departure_date", comment: "")
        view.datePickerMode = .date
        view.delegate = self
        return view
    }()
    
    private lazy var arrivalView: FlightsDateRowView = {
        let view = FlightsDateRowView()
        view.placeholder = NSLocalizedString("flights_arrival_date", comment: "")
        view.datePickerMode = .date
        view.delegate = self
        return view
    }()

    private let passenger = FlightsPassengersRowView()
    
    private let findButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("find", comment: ""), for: .normal)
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
        setupTitle()
        setupSubTitle()
    }
}

extension FlightsViewController: FlightsViewProtocol {
    private func setupTitle() {
        titleLabel.text = NSLocalizedString("split_the_payment", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColor.PrimaryColors.Primary.color500
        titleLabel.applyTypography(.displaySm(weight: .bold))

        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(98)),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
    }
    
    private func setupSubTitle() {
        subTitleLabel.text = NSLocalizedString("with_other_passengers", comment: "")
        subTitleLabel.textAlignment = .left
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textColor = AppColor.PrimaryColors.Gray.color700
        subTitleLabel.applyTypography(.displaySm(weight: .bold))

        view.addSubview(subTitleLabel)
        view.addSubview(flightsLocationView)
        view.addSubview(departureView)
        view.addSubview(arrivalView)
        view.addSubview(passenger)
        view.addSubview(findButton)
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(4)),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(20))
        ])
        
        flightsLocationView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(12)
        }
        
        departureView.snp.makeConstraints { make in
            make.top.equalTo(flightsLocationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }
        
        arrivalView.snp.makeConstraints { make in
            make.top.equalTo(departureView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }
        
        passenger.snp.makeConstraints { make in
            make.top.equalTo(arrivalView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }
        
        findButton.snp.makeConstraints { make in
            make.top.equalTo(passenger.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
        }
    }
}

extension FlightsViewController {
    private func setupLocationEvents() {
        flightsLocationView.onLocationTap = { [weak self] field in
            self?.presentLocationFinder(for: field)
        }
    }

    private func presentLocationFinder(for field: LocationField) {
        let picker = LocationFinder()
        picker.onConfirm = { [weak self] location in
            self?.flightsLocationView.setLocation(location, for: field)
        }

        present(picker, animated: true)
    }
}

extension FlightsViewController: FlightsDateRowViewDelegate {
    func dateInputView(_ view: FlightsDateRowView, didSelectDate date: Date) {
        
    }
    
    func dateInputViewDidTap(_ view: FlightsDateRowView) {
        
    }
    
    func dateInputViewDidCancel(_ view: FlightsDateRowView) {
        
    }
}
