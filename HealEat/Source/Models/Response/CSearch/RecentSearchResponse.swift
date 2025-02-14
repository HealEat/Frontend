// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct RecentSearchResponse: Codable {
    let recentSearchList: [RecentSearchItem]?
    let listSize: Int  // 흠.. 나중에 수정? 
}

struct RecentSearchItem: Codable {
    let recentSearchId: Int
    let searchType: SearchType
    let placeId: Int?
    let query: String
}

enum SearchType: String, Codable {
    case store = "STORE"
    case query = "QUERY"
}
