//
//  UserModel.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 21/03/2026.
//

import Foundation

struct UserModel: Codable {
    let uid: String
    let email: String
    let name: String
    let avatar: String
    let phone: String
    let createdAt: Date
}
