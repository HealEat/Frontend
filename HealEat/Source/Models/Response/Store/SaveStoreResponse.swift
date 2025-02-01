// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct SaveStoreResponseEntity: Codable {
    let storeId: Int?
    let placeName: String?
    let createdAt: String?
}

struct SaveStoreResponseModel: Codable {
    let storeId: Int
    let placeName: String
    let createdAt: Date
    
    init(saveStoreResponseEntity: SaveStoreResponseEntity) {
        self.storeId = saveStoreResponseEntity.storeId ?? 0
        self.placeName = saveStoreResponseEntity.placeName ?? ""
        self.createdAt = saveStoreResponseEntity.createdAt?.convertISO8601ToDate() ?? Date()
    }
}
