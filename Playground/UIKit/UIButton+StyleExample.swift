//
//  UIButton+StyleExample.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

final class UIButtonStyleExample: BaseViewController {
    // 1. Filled – Big
    private let confirmButton = UIButton(type: .system)
    // 2. Filled Rounded – Middle
    private let nextButton = UIButton(type: .system)
    // 3. Outlined – Small
    private let cancelButton = UIButton(type: .system)
    // 4. Outlined Rounded – Big
    private let skipButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.setTitle("Xác nhận", for: .normal)
        confirmButton.applyButtonStyle(.defaultButton(size: .big))
        
        nextButton.setTitle("Tiếp theo", for: .normal)
        nextButton.applyButtonStyle(.roundedButton(size: .middle))
        
        cancelButton.setTitle("Huỷ", for: .normal)
        cancelButton.applyButtonStyle(.outlinedButton(size: .small))
        
        skipButton.setTitle("Bỏ qua", for: .normal)
        skipButton.applyButtonStyle(.outlinedRoundedButton(size: .big))
        
        // 5. Disabled state
        confirmButton.isEnabled = false
        
        // 6. With SnapKit
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
