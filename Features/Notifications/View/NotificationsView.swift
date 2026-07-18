//
//  NotificationsView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 08/03/2026.
//

import UIKit
import SwiftUI
import SnapKit

final class NotificationsView: BaseViewController, NotificationsViewProtocol {
    private let presenter: NotificationsPresenter
    private let topNavigatorVC: TopNavigatorView
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var items: [NotificationsEntity] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: NotificationsPresenter) {
        self.presenter = presenter
        self.topNavigatorVC = TopNavigatorView(topNavigatorTile: NSLocalizedString("notifications", comment: ""))
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Setup UI
private extension NotificationsView {
    func setupUI() {
        view.backgroundColor = .systemBackground
        embedTopNavigator()
    }

    func embedTopNavigator() {
        addChild(topNavigatorVC)
        view.addSubview(topNavigatorVC.view)
        topNavigatorVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        topNavigatorVC.didMove(toParent: self)
        topNavigatorVC.onCloseAction = { [weak self] in
            self?.presenter.dismiss()
        }
    }

    func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topNavigatorVC.view.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        tableView.register(NotificationTableCell.self,
                           forCellReuseIdentifier: NotificationTableCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }

    func loadData() {
        items = presenter.getNotifications()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NotificationsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        items[section].notificationItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationTableCell.identifier,
            for: indexPath
        ) as? NotificationTableCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.section].notificationItems[indexPath.row]

        cell.configure(item: item, parent: self)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        56
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {

        let container = UIView()

        let label = UILabel()
        label.text = items[section].date
        label.applyTypography(.textSm(weight: .regular))
        label.textColor = AppColor.PrimaryColors.Gray.color500

        container.addSubview(label)

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-8)
        }

        return container
    }
}

// MARK: - NotificationTableCell
final class NotificationTableCell: UITableViewCell {
    static let identifier = "NotificationTableCell"

    private var host: UIHostingController<NotificationCardView>?

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        host?.view.removeFromSuperview()
        host = nil
    }

    func configure(item: NotificationItem,
                   parent: UIViewController) {

        let swiftUIView = NotificationCardView(item: item)

        let host = UIHostingController(rootView: swiftUIView)
        self.host = host

        host.view.backgroundColor = .clear

        parent.addChild(host)
        contentView.addSubview(host.view)

        host.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        host.didMove(toParent: parent)
    }
}
