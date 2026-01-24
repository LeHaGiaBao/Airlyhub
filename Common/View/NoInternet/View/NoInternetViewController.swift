//
//  NoInternetViewController.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Foundation
import UIKit

final class NoInternetViewController: UIViewController, NoInternetProtocols {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func show() {
        view.backgroundColor = AppColor.PrimaryColors.Primary.color500
    }
    
    func hide() {
        view.backgroundColor = .clear
    }
}
