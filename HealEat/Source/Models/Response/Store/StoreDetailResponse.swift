// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct StoreDetailResponseEntity: Codable {
    struct StoreInfoDto: Codable {
        let placeId: Int?
        let placeName: String?
        let categoryName: String?
        let phone: String?
        let addressName: String?
        let roadAddressName: String?
        let x: String?
        let y: String?
        let placeUrl: String?
        let features: [String]?
    }
    struct IsInDBDto: Codable {
        let totalScore: Float?
        let reviewCount: Int?
        let sickScore: Float?
        let sickCount: Int?
        let vegetScore: Float?
        let vegetCount: Int?
        let dietScore: Float?
        let dietCount: Int?
    }
    struct TotalStatDto: Codable {
        let tastyScore: Float?
        let cleanScore: Float?
        let freshScore: Float?
        let nutrScore: Float?
    }
    let storeId: Int?
    let createdAt: String?
    let storeInfoDto: StoreInfoDto?
    let isInDBDto: IsInDBDto?
    let totalStatDto: TotalStatDto?
    let bookmarkId: Int?
}

struct StoreDetailResponseModel: Codable {
    struct StoreInfoDto: Codable {
        let placeId: Int
        let placeName: String
        let categoryName: String
        let phone: String
        let addressName: String
        let roadAddressName: String
        let x: Float
        let y: Float
        let placeUrl: URL?
        let features: [String]
        
        init(storeInfoDto: StoreDetailResponseEntity.StoreInfoDto?) {
            self.placeId = storeInfoDto?.placeId ?? 0
            self.placeName = storeInfoDto?.placeName ?? ""
            self.categoryName = storeInfoDto?.categoryName ?? ""
            self.phone = storeInfoDto?.phone ?? ""
            self.addressName = storeInfoDto?.addressName ?? ""
            self.roadAddressName = storeInfoDto?.roadAddressName ?? ""
            self.x = Float(storeInfoDto?.x ?? "") ?? 0
            self.y = Float(storeInfoDto?.y ?? "") ?? 0
            self.placeUrl = URL(string: storeInfoDto?.placeUrl ?? "")
            self.features = storeInfoDto?.features ?? []
        }
    }
    struct IsInDBDto: Codable {
        let totalScore: Float
        let reviewCount: Int
        let sickScore: Float
        let sickCount: Int
        let vegetScore: Float
        let vegetCount: Int
        let dietScore: Float
        let dietCount: Int
        
        init(isInDBDto: StoreDetailResponseEntity.IsInDBDto?) {
            self.totalScore = isInDBDto?.totalScore ?? 0
            self.reviewCount = isInDBDto?.reviewCount ?? 0
            self.sickScore = isInDBDto?.sickScore ?? 0
            self.sickCount = isInDBDto?.sickCount ?? 0
            self.vegetScore = isInDBDto?.vegetScore ?? 0
            self.vegetCount = isInDBDto?.vegetCount ?? 0
            self.dietScore = isInDBDto?.dietScore ?? 0
            self.dietCount = isInDBDto?.dietCount ?? 0
        }
    }
    struct TotalStatDto: Codable {
        let tastyScore: Float
        let cleanScore: Float
        let freshScore: Float
        let nutrScore: Float
        
        init(totalStatDto: StoreDetailResponseEntity.TotalStatDto?) {
            self.tastyScore = totalStatDto?.tastyScore ?? 0
            self.cleanScore = totalStatDto?.cleanScore ?? 0
            self.freshScore = totalStatDto?.freshScore ?? 0
            self.nutrScore = totalStatDto?.nutrScore ?? 0
        }
    }
    let storeId: Int
    let createdAt: Date
    let storeInfoDto: StoreInfoDto
    let isInDBDto: IsInDBDto
    let totalStatDto: TotalStatDto
    var bookmarkId: Int?
    
    init(storeDetailResponseEntity: StoreDetailResponseEntity) {
        self.storeId = storeDetailResponseEntity.storeId ?? 0
        self.createdAt = storeDetailResponseEntity.createdAt?.convertISO8601ToDate() ?? Date()
        self.storeInfoDto = StoreInfoDto(storeInfoDto: storeDetailResponseEntity.storeInfoDto)
        self.isInDBDto = IsInDBDto(isInDBDto: storeDetailResponseEntity.isInDBDto)
        self.totalStatDto = TotalStatDto(totalStatDto: storeDetailResponseEntity.totalStatDto)
        self.bookmarkId = storeDetailResponseEntity.bookmarkId
    }
}
