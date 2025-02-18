// Copyright © 2025 HealEat. All rights reserved.

import Foundation

class SortSelectionManager {
    static let shared = SortSelectionManager() // ✅ 싱글톤 인스턴스

    private let searchByKey = "searchBy"
    private let sortByKey = "sortBy"

    // ✅ 초기값 (정확성 / 별점순)
    var searchBy: SearchBy {
        get {
            let value = UserDefaults.standard.string(forKey: searchByKey) ?? SearchBy.accuracy.rawValue
            return SearchBy(rawValue: value) ?? .accuracy
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: searchByKey)
        }
    }

    var sortBy: SortBy {
        get {
            let value = UserDefaults.standard.string(forKey: sortByKey) ?? SortBy.rating.rawValue
            return SortBy(rawValue: value) ?? .rating
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: sortByKey)
        }
    }
}


