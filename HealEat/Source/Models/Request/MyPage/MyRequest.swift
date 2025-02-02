// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct MyProfileRequest: Codable {
    let name: String
    let profileImageUrl: String
}

struct HealthInfoAnswerRequest: Codable {
    let selectedAnswers: [String]
}

