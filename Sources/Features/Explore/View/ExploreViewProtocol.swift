//
//  ExploreViewProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol ExploreViewProtocol: AnyObject {
    func showHelpfulInformation(_ items: [HelpfulInformationItem])
    func showError(_ message: String)
}
