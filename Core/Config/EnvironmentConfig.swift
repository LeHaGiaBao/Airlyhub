//
//  EnvironmentConfig.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

protocol EnvironmentConfig {
    var locationSearchBaseURL: String { get }
}

enum AppEnvironment {
    static let current: EnvironmentConfig = {
        switch AppConfig.environment {
        case .dev:  return DevConfig()
        case .stg:  return StagingConfig()
        case .prod: return ProdConfig()
        }
    }()
}
