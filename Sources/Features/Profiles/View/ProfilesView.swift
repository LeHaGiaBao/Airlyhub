//
//  ProfilesView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit
import RxSwift

final class ProfilesView: BaseViewController, ProfilesViewProtocol {
    var presenter: ProfilesPresenterProtocol
    private let bag = DisposeBag()

    private let headerContainerView = UIView()
    private let tableContainerView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private var menuItems: [ProfilesMenuSection] = []

    private let avatarImageView = UIImageView()
    private let editAvatarButton = UIButton(type: .system)
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
        setupEvents()
    }

    private func setupUI() {
        view.backgroundColor = AppColor.PrimaryColors.Gray.color50

        headerContainerView.backgroundColor = .white
        headerContainerView.layer.cornerRadius = 20
        headerContainerView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        headerContainerView.layer.masksToBounds = true
        view.addSubview(headerContainerView)

        let headerStack = UIStackView(arrangedSubviews: [
            avatarImageView,
            nameLabel,
            phoneLabel
        ])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerContainerView.addSubview(headerStack)
        headerContainerView.addSubview(editAvatarButton)

        tableContainerView.backgroundColor = .white
        tableContainerView.layer.cornerRadius = 20
        tableContainerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        tableContainerView.layer.masksToBounds = true
        view.addSubview(tableContainerView)

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

        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            headerStack.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 98),
            headerStack.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -24),
            headerStack.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -16),

            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),

            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 2),
            editAvatarButton.widthAnchor.constraint(equalToConstant: 28),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 28),

            tableContainerView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 16),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor)
        ])

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func setupHeaderContent() {
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.tintColor = AppColor.PrimaryColors.Primary.color300
        avatarImageView.backgroundColor = AppColor.PrimaryColors.Primary.color50

        nameLabel.applyTypography(.displayXs(weight: .semibold))
        nameLabel.textColor = AppColor.PrimaryColors.Gray.color800

        phoneLabel.applyTypography(.textSm(weight: .medium))
        phoneLabel.textColor = AppColor.PrimaryColors.Gray.color500

        editAvatarButton.backgroundColor = .white
        editAvatarButton.layer.cornerRadius = 14
        editAvatarButton.tintColor = AppColor.PrimaryColors.Gray.color800
        editAvatarButton.setImage(AssetsIcon.pencil, for: .normal)
        editAvatarButton.layer.shadowColor = UIColor.black.cgColor
        editAvatarButton.layer.shadowOpacity = 0.15
        editAvatarButton.layer.shadowRadius = 3
        editAvatarButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    private func updateUserProfile() {
        presenter.getUserProfile()
            .subscribe(onNext: { [weak self] profile in
                self?.nameLabel.text = profile.name
                self?.phoneLabel.text = profile.phone
                self?.avatarImageView.setImage(
                    from: profile.avatarURL,
                    placeholder: UIImage(systemName: "person.crop.circle.fill")
                )
            })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCardsBadge()
    }

    private func updateMenuItems() {
        let data = presenter.getMenuItems()
        menuItems = data
        tableView.reloadData()
    }

    private func loadCardsBadge() {
        presenter.getCardCount()
            .subscribe(
                onNext: { [weak self] count in
                    self?.applyCardsBadge(count)
                },
                onError: { _ in }
            )
            .disposed(by: bag)
    }

    private func applyCardsBadge(_ count: Int) {
        for (sectionIndex, section) in menuItems.enumerated() {
            guard let rowIndex = section.items.firstIndex(where: {
                if case .cards = $0.type { return true }
                return false
            }) else { continue }

            let current = section.items[rowIndex]
            let updated = ProfilesMenuItem(
                title: current.title,
                iconName: current.iconName,
                type: .cards(badge: count > 0 ? count : nil),
                position: current.position
            )

            var items = section.items
            items[rowIndex] = updated
            menuItems[sectionIndex] = ProfilesMenuSection(items: items)
            tableView.reloadRows(
                at: [IndexPath(row: rowIndex, section: sectionIndex)],
                with: .none
            )
            return
        }
    }

    private func setupEvents() {
        editAvatarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapEditAvatar()
            })
            .disposed(by: disposeBag)
    }

    private func didTapEditAvatar() {
        presenter.navigateToEditProfile()
            .subscribe(onNext: { [weak self] action in
                if case .saved = action {
                    self?.updateUserProfile()
                }
            })
            .disposed(by: bag)
    }
}

extension ProfilesView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfilesMenuCell.identifier,
            for: indexPath
        ) as? ProfilesMenuCell else {
            return UITableViewCell()
        }

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
