//
//  Bundle+Extension.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 18/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

private var bundleAssociationKey: UInt8 = 0

extension Bundle {
    static func setLanguage(_ language: String) {
        object_setClass(Bundle.main, LocalizedBundle.self)

        let bundle: Bundle?
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            bundle = Bundle(path: path)
        } else {
            bundle = nil
        }

        objc_setAssociatedObject(
            Bundle.main,
            &bundleAssociationKey,
            bundle,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}

private final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &bundleAssociationKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}
