// Copyright © 2025 HealEat. All rights reserved.

import Foundation

enum SortEnum: String {
    case defaultValue = "DEFAULT"
    case sick = "SICK"
    case veget = "VEGET"
    case diet = "DIET"
}

enum SortOrderEnum: String {
    case asc
    case desc
}

struct ReviewGetRequest {
    let storeId: Int
    let page: Int
    let sort: SortEnum
    let sortOrder: SortOrderEnum
}
