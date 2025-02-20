// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct InfoProfileRequest: Codable {
    let name: String
    let profileImageUrl: String
}

struct InfoAnswerRequest: Codable {
    let selectedAnswers: [String]
}

struct DiseaseRequest: Codable {
    let diseaseName: String
}
