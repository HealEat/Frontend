// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct HealthGoalResponse: Codable {
    let healthPlanList: [HealthPlan]
}

struct HealthPlan: Codable {
    let id: Int         // planId
    let name: String
    let duration: String
    let goalNumber: Int
    let count: Int
    let goal: String
    let memo: String?
    let memoImages: [MemoImage]
}

struct MemoImage: Codable {
    let id: Int
    let filePath: String
}
