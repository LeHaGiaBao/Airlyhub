//
//  InputState.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/04/2026.
//  Copyright © 2026 airly. All rights reserved.
//

public enum InputState {
    case defaultInput
    case focused
    case filled
    case error(message: String?)
    case warning(message: String?)
    case success
    case disabled
}
