// Copyright © 2025 HealEat. All rights reserved.

import Foundation

// 이미지, 메모는 아직 추가되지 않음
struct HealthGoalRequest: Codable {
    let duration: String
    let number: Int
    let goal: String
}
