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
        view.backgroundColor = AppColor.PrimaryColors.Gray.color25
//        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .fade
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
