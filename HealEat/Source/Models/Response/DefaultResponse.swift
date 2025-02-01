//
//  DefaultResponse.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//

import Foundation

struct DefaultResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}
//필요 없을지도
struct DefaultMultiResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [T]
}
