// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct MyHealthInfoResponse: Codable {
    let healthGoals: [String]
    let vegetarianType: String
    let healthIssues: [String]
    let requiredMeals: [String]
    let requiredNutrients: [String]
    let avoidedFoods: [String]
}
