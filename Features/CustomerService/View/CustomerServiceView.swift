//
//  CustomerServiceView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import UIKit

final class CustomerServiceView: BaseViewController, CustomerServiceViewProtocol {
    private let presenter: CustomerServicePresenter
    private let topNavigatorVC: TopNavigatorView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: CustomerServicePresenter) {
        self.presenter = presenter
        self.topNavigatorVC = TopNavigatorView(
            topNavigatorTile: NSLocalizedString("customer_service", comment: "")
        )
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        embedTopNavigator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func embedTopNavigator() {
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
}
