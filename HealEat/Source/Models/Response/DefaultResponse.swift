//
//  DefaultResponse.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//
// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct DefaultResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}

struct DefaultMultiResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [T]
}
