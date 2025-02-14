// Copyright © 2025 HealEat. All rights reserved.

import Foundation

extension Date {
    var toStringYYYYMMDD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
