//
//  ProfilesView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit
import RxSwift

final class ProfilesView: BaseViewController {
    var presenter: ProfilesPresenterProtocol
    private let bag = DisposeBag()
    
    // MARK: - Views
    private let headerContainerView = UIView()
    private let tableContainerView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Data
    private var menuItems: [ProfilesMenuSection] = []

    // MARK: - Header UI
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: ProfilesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupHeaderContent()
        updateUserProfile()
        updateMenuItems()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = AppColor.PrimaryColors.Gray.color50

        // MARK: Header container
        headerContainerView.backgroundColor = .white
        headerContainerView.layer.cornerRadius = 20
        headerContainerView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        headerContainerView.layer.masksToBounds = true
        view.addSubview(headerContainerView)

        // MARK: Header stack
        let headerStack = UIStackView(arrangedSubviews: [
            avatarImageView,
            nameLabel,
            phoneLabel
        ])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerContainerView.addSubview(headerStack)

        // MARK: Table container
        tableContainerView.backgroundColor = .white
        tableContainerView.layer.cornerRadius = 20
        tableContainerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        tableContainerView.layer.masksToBounds = true
        view.addSubview(tableContainerView)

        // MARK: TableView
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero

        tableView.register(
            ProfilesMenuCell.self,
            forCellReuseIdentifier: ProfilesMenuCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self

        tableContainerView.addSubview(tableView)

        // MARK: AutoLayout
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // MARK: Header container (FULL WIDTH)
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // MARK: Header stack padding (16 horizontal)
            headerStack.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 98),
            headerStack.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -24),
            headerStack.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -16),

            // MARK: Avatar
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),

            // MARK: Table container (FULL WIDTH)
            tableContainerView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 16),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // MARK: TableView full inside container
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor)
        ])

        // iOS 15+ fix
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    // MARK: - Header Content
    private func setupHeaderContent() {
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = AppColor.PrimaryColors.Primary.color50

        nameLabel.applyTypography(.displayXs(weight: .semibold))
        nameLabel.textColor = AppColor.PrimaryColors.Gray.color800

        phoneLabel.applyTypography(.textSm(weight: .medium))
        phoneLabel.textColor = AppColor.PrimaryColors.Gray.color500
    }
    
    private func updateUserProfile() {
        let data = presenter.getUserProfile()
        nameLabel.text = data.name
        phoneLabel.text = data.phone
    }
    
    private func updateMenuItems() {
        let data = presenter.getMenuItems()
        menuItems = data
        tableView.reloadData()
    }
}

// MARK: - TableView
extension ProfilesView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfilesMenuCell.identifier,
            for: indexPath
        ) as! ProfilesMenuCell

        let item = menuItems[indexPath.section].items[indexPath.row]
        cell.configure(item, position: item.position)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.section].items[indexPath.row]
        switch item.type {
        case .notifications:
            presenter.navigateToNotifications()
                    .subscribe()
                    .disposed(by: bag)
        case .tickets:
            presenter.navigateToMyTickets()
                    .subscribe()
                    .disposed(by: bag)
        case .cards:
            presenter.navigateToMyCards()
                    .subscribe()
                    .disposed(by: bag)
        case .customerService:
            presenter.navigateToCustomerService()
                    .subscribe()
                    .disposed(by: bag)
        case .settings:
            presenter.navigateToSettings()
                    .subscribe()
                    .disposed(by: bag)
        case .logout:
            presenter.goToLogout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

