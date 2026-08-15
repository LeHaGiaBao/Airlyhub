//
//  CustomerServicePresenterProtocol.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol CustomerServicePresenterProtocol: AnyObject {
    func viewDidLoad()
    func sendTapped(text: String, attachment: ChatAttachmentDraft?)
    func dismiss()
}
