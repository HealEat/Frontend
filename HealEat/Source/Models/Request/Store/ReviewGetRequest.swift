// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ReviewsRequest {
    let placeId: Int
    let page: Int
    let sortBy: SortEnum
    let filters: Set<FilterEnum>
}
