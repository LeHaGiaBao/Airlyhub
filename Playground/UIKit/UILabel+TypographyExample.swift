//
//  UILabel+TypographyExample.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit

final class UILabelTypographyExample: BaseViewController {
    private let titleLabel = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Example using Typography UIKit"
        titleLabel.applyTypography(.display2Xl(weight: .bold))
    }
}
