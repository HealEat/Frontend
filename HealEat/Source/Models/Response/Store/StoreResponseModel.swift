// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct StoreResponseModel: Codable {
    let placeId: Int
    let placeName: String
    let categoryName: String
    let phone: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let placeUrl: URL
    let features: [String]
    let imageUrls: [URL]
    
    let isInDB: Bool
    
    let totalScore: Float
    let reviewCount: Int
    let sickScore: Float
    let sickCount: Int
    let vegetScore: Float
    let vegetCount: Int
    let dietScore: Float
    let dietCount: Int
    
    let isBookMarked: Bool
}
