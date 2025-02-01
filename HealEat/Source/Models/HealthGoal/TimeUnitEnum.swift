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
    
    /// 한국어 값을 받아서 `TimeUnit`으로 변환
       static func fromKorean(_ korean: String) -> TimeUnit? {
           return self.allCases.first { $0.inKorean == korean }
       }

       /// 한국어 값을 받아서 `rawValue` (ENUM 문자열)로 변환
       static func rawValue(fromKorean korean: String) -> String? {
           return self.fromKorean(korean)?.rawValue
       }
}
