//
//  Validation.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 16/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum Validation {

    static func required(_ value: String?, message: String? = nil) -> ValidationResult {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .invalid(message: message ?? NSLocalizedString("validation_required_default", comment: ""))
        }
        return .valid
    }

    static func validFullName(_ value: String?, message: String? = nil) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_fullname", comment: ""))
        }
        guard Regexes.matches(Regexes.vietnameseNameCharacters, input: value) else {
            return .invalid(message: message ?? NSLocalizedString("validation_invalid_fullname", comment: ""))
        }
        return .valid
    }

    static func validSignUpFullName(_ value: String?) -> ValidationResult {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_fullname", comment: ""))
        }
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard (2...50).contains(trimmed.count),
              Regexes.matches(Regexes.vietnameseNameCharacters, input: trimmed) else {
            return .invalid(message: NSLocalizedString("validation_invalid_fullname", comment: ""))
        }
        return .valid
    }

    static func validPhone(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_phone", comment: ""))
        }
        guard Regexes.matches(Regexes.phoneWithElevenNumberAnd84, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_phone", comment: ""))
        }
        return .valid
    }

    static func validEmail(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_email", comment: ""))
        }
        guard Regexes.matches(Regexes.email, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_email", comment: ""))
        }
        return .valid
    }

    static func validEmailOptional(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else { return .valid }
        guard Regexes.matches(Regexes.email, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_email", comment: ""))
        }
        return .valid
    }

    static func validPassword(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_password", comment: ""))
        }
        guard value.count >= 6 else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_too_short", comment: ""))
        }
        guard Regexes.matches(Regexes.password, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_format", comment: ""))
        }
        return .valid
    }

    static func validRePassword(_ value: String?, matching ref: String?) -> ValidationResult {
        let base = validPassword(value)
        guard base.isValid else { return base }
        guard value == ref else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_not_matching", comment: ""))
        }
        return .valid
    }

    static func validNewPassword(_ value: String?, notSameAs oldPassword: String?) -> ValidationResult {
        let base = validPassword(value)
        guard base.isValid else { return base }
        guard value != oldPassword else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_same_as_old", comment: ""))
        }
        return .valid
    }

    static func validSignUpPassword(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_password", comment: ""))
        }
        guard value.count >= 6 else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_too_short", comment: ""))
        }
        guard value.count <= 150 else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_too_long", comment: ""))
        }
        return .valid
    }

    static func validSignUpRePassword(_ value: String?, matching ref: String?) -> ValidationResult {
        let base = validSignUpPassword(value)
        guard base.isValid else { return base }
        guard value == ref else {
            return .invalid(message: NSLocalizedString("validation_invalid_password_not_matching", comment: ""))
        }
        return .valid
    }

    static func validUsername(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message: NSLocalizedString("validation_required_username", comment: ""))
        }
        guard value.count >= 3 else {
            return .invalid(message: NSLocalizedString("validation_invalid_username_min_length", comment: ""))
        }
        guard Regexes.matches(Regexes.username, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_username_format", comment: ""))
        }
        return .valid
    }

    static func validDateOfBirth(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else { return .valid }

        guard Regexes.matches(Regexes.dateOfBirth, input: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_dob_format", comment: ""))
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: value) else {
            return .invalid(message: NSLocalizedString("validation_invalid_dob_parse", comment: ""))
        }

        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        var minComps = DateComponents(); minComps.year = 1900; minComps.month = 1; minComps.day = 1
        var maxComps = DateComponents(); maxComps.year = currentYear - 16; maxComps.month = 1; maxComps.day = 1

        guard let minDate = calendar.date(from: minComps), let maxDate = calendar.date(from: maxComps) else {
            return .invalid(message: NSLocalizedString("validation_invalid_dob_parse", comment: ""))
        }

        if date < minDate || date > maxDate {
            let comment = "Date must be between 01/01/1900 and 01/01/\(currentYear - 16)"
            let msg = NSLocalizedString("validation_invalid_dob_range", comment: comment)
            return .invalid(message: msg)
        }

        return .valid
    }

    static func requiredOTP(_ value: String?, message: String? = nil) -> ValidationResult {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .invalid(message: message ?? NSLocalizedString("validation_required_otp", comment: ""))
        }
        return .valid
    }

    static func requiredIdentify(_ value: String?, message: String? = nil) -> ValidationResult {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .invalid(message: message ?? NSLocalizedString("validation_required_identify", comment: ""))
        }
        return .valid
    }
}
