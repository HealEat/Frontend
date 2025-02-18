// Copyright © 2025 HealEat. All rights reserved.

import Foundation


enum HealthPlanStatus: String, Codable {
    case fail = "FAIL"
    case progress = "PROGRESS"
    case complete = "COMPLETE"
    
    var title: String {
        switch self {
        case .fail:
            return "달성 실패"
        case .progress:
            return "진행 중"
        case .complete:
            return "달성 완료"
        }
    }
}

enum HealthPlanDuration: String, Codable, CaseIterable {
    case day = "DAY"
    case week = "WEEK"
    case day10 = "DAY10"
    case month = "MONTH"
    
    var title: String {
        switch self {
        case .day:
            return "하루"
        case .week:
            return "일주일"
        case .day10:
            return "열흘"
        case .month:
            return "한달"
        }
    }
    
    
    static func fromKorean(_ korean: String) -> HealthPlanDuration? {
        return self.allCases.first { $0.title == korean }
    }

    /// 한국어 값을 받아서 `rawValue` (ENUM 문자열)로 변환
    static func rawValue(fromKorean korean: String) -> String {
        return self.fromKorean(korean)?.rawValue ?? ""
    }
}
