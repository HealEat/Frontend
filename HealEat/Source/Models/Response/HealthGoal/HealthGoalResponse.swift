// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct HealthGoalResponse: Codable {
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    let healthPlanList: [HealthPlan]
}

struct HealthPlan: Codable {
    let id: Int         // planId
    let name: String
    let duration: HealthPlanDuration
    let goalNumber: Int
    let status: HealthPlanStatus
    let goal: String
    let memo: String?
    let healthPlanImages: [MemoImage]
}

struct MemoImage: Codable {
    let id: Int
    let imageUrl: String
}
