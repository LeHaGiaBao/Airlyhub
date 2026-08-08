//
//  Regexes.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 16/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

enum Regexes {
    // Regex literals must stay on one line — splitting them would change the pattern.
    // swiftlint:disable line_length
    static let phone                      = #"^0\d{9}$"#
    static let phoneWithOrWithoutZero     = #"^(?:(?=0)[0]([0-9]{9,10})|(?:(?=[3|5|7|8|9])[3|5|7|8|9]([0-9]{8,9})))$"#
    static let numberOnly                 = #"^\d+$"#
    static let email                      = #"^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"#
    static let username                   = #"^(?=[a-z0-9._]{3,30}$)(?!.*[_.]{2})[^_.].*[^_.]$"#
    static let alphanumeric               = #"^[A-Za-z0-9 ]*$"#
    static let password                   = #"^([A-Za-z0-9!@#$%^&*._]){6,}$"#
    static let vietnameseAlphanumeric     = #"^[0-9a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀẾỂưăạảấầẩẫậắằẳẵặẹẻẽềếểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý,\s]*$"#
    static let vietnameseNameCharacters   = #"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀẾỂưăạảấầẩẫậắằẳẵặẹẻẽềếểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý\'\" \s]*$"#
    static let vietnameseCharacters       = #"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀẾỂưăạảấầẩẫậắằẳẵặẹẻẽềếểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý\s]*$"#
    static let phoneWithElevenNumberAnd84 = #"^(?:^[1-9]\d{8}|0\d{9}|84[1-9]\d{8})$"#
    static let dateOfBirth                = #"^[0-9]{2}\/[0-9]{2}\/[1-2]{1}[0-9]{3}$"#
    // Embossed cardholder names are Latin-only: letters, spaces, hyphens, apostrophes, periods.
    static let cardHolderName             = #"^[A-Za-z][A-Za-z\-\.\' ]{1,25}$"#
    // swiftlint:enable line_length

    static func matches(_ pattern: String, input: String) -> Bool {
        return input.range(of: pattern, options: .regularExpression) != nil
    }
}
