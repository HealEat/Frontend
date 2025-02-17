// Copyright © 2025 HealEat. All rights reserved.

import Foundation


struct HealthGoalRequest: Codable {
    let duration: String
    let number: Int
    let goal: String
    let removeImageIds: [Int]
}

struct ChangeHealthGoalRequest: Codable {
    let updateRequest: HealthGoalRequest
    let images: [Data]
}


