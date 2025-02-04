// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct MyHealthInfoResponse: Codable {
    let diseases: [String]
    // enum type으로 추정
    let vegetarian: String
    let diet: String
    let qnas: [HealthInfoQna]
}

struct HealthInfoQna: Codable {
    // enum type
    let question: String
    let answers: [String]
}
