//
//  MyCardsView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit
import SnapKit

final class MyCardsView: BaseViewController {
    private enum Section: Int, CaseIterable {
        case cards
        case addNew
    }

    private let presenter: MyCardsPresenterProtocol
    private let topNavigatorVC: TopNavigatorView

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let errorLabel = UILabel()

    private var items: [CardItem] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: MyCardsPresenterProtocol) {
        self.presenter = presenter
        self.topNavigatorVC = TopNavigatorView(topNavigatorTile: NSLocalizedString("my_cards", comment: ""))
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        embedTopNavigator()
        setupTableView()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /// Composite icon + label for the swipe action. `UIContextualAction` renders either a
    /// title or an image, never both, so the design's "⊗ Delete" pairing is drawn into one image.
    private lazy var deleteActionImage: UIImage? = {
        let tint = AppColor.PrimaryColors.Error.color500 ?? .systemRed
        let icon = (AssetsIcon.xcircle ?? UIImage(systemName: "xmark.circle.fill"))?
            .withTintColor(tint, renderingMode: .alwaysOriginal)
        let title = NSLocalizedString("delete", comment: "")

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: tint
        ]

        let iconSize = CGSize(width: 20, height: 20)
        let spacing: CGFloat = 6
        let titleSize = (title as NSString).size(withAttributes: attributes)
        let totalSize = CGSize(
            width: iconSize.width + spacing + titleSize.width,
            height: max(iconSize.height, titleSize.height)
        )

        let renderer = UIGraphicsImageRenderer(size: totalSize)
        return renderer.image { _ in
            icon?.draw(in: CGRect(
                origin: CGPoint(x: 0, y: (totalSize.height - iconSize.height) / 2),
                size: iconSize
            ))
            (title as NSString).draw(
                at: CGPoint(x: iconSize.width + spacing, y: (totalSize.height - titleSize.height) / 2),
                withAttributes: attributes
            )
        }.withRenderingMode(.alwaysOriginal)
    }()
}

// MARK: - UI
private extension MyCardsView {
    func setupUI() {
        view.backgroundColor = .systemBackground

        errorLabel.applyTypography(.textSm(weight: .regular))
        errorLabel.textColor = AppColor.PrimaryColors.Gray.color500
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        activityIndicator.hidesWhenStopped = true
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: CardCell.identifier)
        tableView.register(AddNewCardCell.self, forCellReuseIdentifier: AddNewCardCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tableView.keyboardDismissMode = .onDrag

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topNavigatorVC.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }

        errorLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
}

// MARK: - UITableViewDataSource
extension MyCardsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .cards: return items.count
        case .addNew: return 1
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .cards:
            guard indexPath.row < items.count,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
                return UITableViewCell()
            }
            cell.configure(items[indexPath.row])
            return cell

        case .addNew:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AddNewCardCell.identifier, for: indexPath) as? AddNewCardCell else {
                return UITableViewCell()
            }
            return cell

        case .none:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension MyCardsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section) {
        case .cards:
            guard indexPath.row < items.count else { return }
            FeedbackGenerator.onFeedbackGenerator(.light)
            presenter.cardSelected(id: items[indexPath.row].id)

        case .addNew:
            FeedbackGenerator.onFeedbackGenerator(.light)
            presenter.addCardTapped()

        case .none:
            break
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Only card rows are swipeable — the "Add new card" row must not be.
        guard Section(rawValue: indexPath.section) == .cards,
              indexPath.row < items.count else { return nil }

        let item = items[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            // `false` springs the row back: nothing has been deleted yet, and won't be
            // until the confirmation sheet comes back positive.
            completion(false)
            FeedbackGenerator.onFeedbackGenerator(.medium)
            self?.presenter.deleteRequested(id: item.id)
        }

        action.image = deleteActionImage
        action.backgroundColor = AppColor.PrimaryColors.Gray.color50 ?? .systemGroupedBackground

        let configuration = UISwipeActionsConfiguration(actions: [action])
        // A destructive, non-undoable action should never fire from a fast full swipe.
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - MyCardsViewProtocol
extension MyCardsView: MyCardsViewProtocol {
    func render(_ state: MyCardsViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = items.isEmpty

        case .loaded(let items):
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = false
            self.items = items
            tableView.reloadData()

        case .failed(let message):
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    func showToast(_ message: String, style: ToastStyle) {
        ToastView.show(message, style: style, in: view)
    }
}
