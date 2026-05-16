//
//  ValidationResult.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 16/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum ValidationResult: Equatable {
    case valid
    case invalid(message: String)

    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .invalid(let msg) = self { return msg }
        return nil
    }
}
