// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct BookmarkResponseEntity: Codable {
    let bookmarkId: Int?
    let memberId: Int?
    let placeName: String?
    let createdAt: String?
    let deletedAt: String?
}

struct BookmarkResponseModel: Codable {
    let bookmarkId: Int
    let memberId: Int
    let placeName: String
    let createdAt: Date
    let deletedAt: Date
    
    init(bookmarkResponseEntity: BookmarkResponseEntity) {
        self.bookmarkId = bookmarkResponseEntity.bookmarkId ?? 0
        self.memberId = bookmarkResponseEntity.memberId ?? 0
        self.placeName = bookmarkResponseEntity.placeName ?? ""
        self.createdAt = bookmarkResponseEntity.createdAt?.convertISO8601ToDate() ?? Date()
        self.deletedAt = bookmarkResponseEntity.deletedAt?.convertISO8601ToDate() ?? Date()
    }
}
