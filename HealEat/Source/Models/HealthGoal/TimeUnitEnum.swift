// Copyright © 2025 HealEat. All rights reserved.

import Foundation

enum TimeUnit: String, CaseIterable {
    case day = "DAY"
    case week = "WEEK"
    case tenDay = "DAY10"
    case month = "MONTH"
    case none = ""
    
    var inKorean: String {
        switch self {
        case .day: return "매일"
        case .week: return "일주일"
        case .tenDay: return "열흘"
        case .month: return "한달"
        case .none: return ""
        }
    }
}
