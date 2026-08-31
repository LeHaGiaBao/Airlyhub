//
//  BaseViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.BaseColor.backgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
