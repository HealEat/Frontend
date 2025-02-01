// Copyright © 2025 HealEat. All rights reserved.

import Foundation

extension String {
    // 2025-01-10T05:42:44.858Z
    func convertISO8601ToDate() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.date(from: self)
    }
}
