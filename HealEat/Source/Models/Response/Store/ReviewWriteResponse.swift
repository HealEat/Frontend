// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ReviewWriteResponseEntity: Codable {
    let reviewId: Int?
    let imageCount: Int?
    let createdAt: String?
}

struct ReviewWriteResponseModel: Codable {
    let reviewId: Int
    let imageCount: Int
    let createdAt: Date
    
    init(reviewWriteResponseEntity: ReviewWriteResponseEntity) {
        self.reviewId = reviewWriteResponseEntity.reviewId ?? 0
        self.imageCount = reviewWriteResponseEntity.imageCount ?? 0
        self.createdAt = reviewWriteResponseEntity.createdAt?.convertISO8601ToDate() ?? Date()
    }
}
