// Copyright © 2025 HealEat. All rights reserved.

import Foundation

extension Date {
    var toStringYYYYMMDD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    var millisecondsSince1970: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    // 밀리초에서 Date 객체 생성
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
