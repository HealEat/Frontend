// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct RecentSearchResponse: Codable {
    let recentSearchList: [RecentSearchItem]?
}

struct RecentSearchItem: Codable {
    let recentSearchId: Int
    let searchType: SearchType
    let placeId: Int?
    let placeName: String?
    let query: String
}

enum SearchType: String, Codable {
    case store = "STORE"
    case query = "QUERY"
}
