// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct CSearchRequest: Codable {
    let query: String
    let x: String
    let y: String
    let categoryIdList: [Int]
    let featureIdList: [Int]
    let minRating: Float
    let searchBy: String
    let sortBy: String
}


struct CSearchRectRequest: Codable {
    let query: String
    let categoryIdList: [Int]
    let featureIdList: [Int]
    let minRating: Float
    let sortBy: String
}
