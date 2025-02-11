// Copyright © 2025 HealEat. All rights reserved.

import Foundation

class CategorySelectionManager {
    static let shared = CategorySelectionManager()

    private let queue = DispatchQueue(label: "categorySelectionManager.queue", attributes: .concurrent)

    private var _selectedFoodIDs: Set<Int> = []
    private var _selectedNutritionIDs: Set<Int> = []

    private init() {}

    // ✅ 총 선택 개수 가져오기 (Thread-safe)
    func getTotalSelectedCount() -> Int {
        return queue.sync {
            return _selectedFoodIDs.count + _selectedNutritionIDs.count
        }
    }

    // ✅ 선택 추가 (Thread-safe, ID 기반)
    func addSelection(_ id: Int, forCategory category: Int) {
        queue.async(flags: .barrier) {
            if category == 0 {
                self._selectedFoodIDs.insert(id)
            } else {
                self._selectedNutritionIDs.insert(id)
            }
        }
    }

    // ✅ 선택 해제 (Thread-safe, ID 기반)
    func removeSelection(_ id: Int, forCategory category: Int) {
        queue.async(flags: .barrier) {
            if category == 0 {
                self._selectedFoodIDs.remove(id)
            } else {
                self._selectedNutritionIDs.remove(id)
            }
        }
    }

    // ✅ 현재 선택된 ID 목록 반환 (Thread-safe)
    func getSelectedItems(forCategory category: Int) -> Set<Int> {
        return queue.sync {
            return category == 0 ? _selectedFoodIDs : _selectedNutritionIDs
        }
    }
}
