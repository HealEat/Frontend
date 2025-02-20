// Copyright © 2025 HealEat. All rights reserved.

import Foundation
// 홈 API 응답 모델
struct HomeResponse: Codable {
    let storeList: [StoreResponse]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    let searchInfo: SearchInfo?
    
    enum CodingKeys: String, CodingKey {
        case storeList
        case listSize
        case totalPage
        case totalElements
        case isFirst
        case isLast
        case searchInfo = "searchInfoDto"
    }
}


// 가게 정보 응답 모델
struct StoreResponse: Codable {
    let id: Int
    let place_name: String
    let category_name: String
    let phone: String?
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let place_url: String
    let imageUrl: String?
    let features: [String]
    let isInDBInfo: IsInDBInfo?
    var bookmarkId: Int?

    enum CodingKeys: String, CodingKey {
        case storeInfoDto
        case imageUrl
        case isInDBInfo = "isInDBDto"
        case bookmarkId
    }

    struct StoreInfo: Codable {
        let placeId: Int
        let placeName: String
        let categoryName: String
        let phone: String?
        let addressName: String
        let roadAddressName: String
        let x: String
        let y: String
        let placeUrl: String
        let features: [String]
    }
    
    struct StoreImageList: Codable {
        let daumImgDocuments: [ImageDocument]
    }
    
    struct ImageDocument: Codable {
        let image_url: String
    }
    // JSON 디코딩
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let storeInfo = try container.decode(StoreInfo.self, forKey: .storeInfoDto)
        self.id = storeInfo.placeId
        self.place_name = storeInfo.placeName
        self.category_name = storeInfo.categoryName
        self.phone = storeInfo.phone
        self.address_name = storeInfo.addressName
        self.road_address_name = storeInfo.roadAddressName
        self.x = storeInfo.x
        self.y = storeInfo.y
        self.place_url = storeInfo.placeUrl
        self.features = storeInfo.features

        // 이미지 URL 가져오기
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""

        self.bookmarkId = try container.decodeIfPresent(Int.self, forKey: .bookmarkId)
        
        self.isInDBInfo = try container.decodeIfPresent(IsInDBInfo.self, forKey: .isInDBInfo)

    }

    // JSON 인코딩
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let storeInfo = StoreInfo(
            placeId: id,
            placeName: place_name,
            categoryName: category_name,
            phone: phone,
            addressName: address_name,
            roadAddressName: road_address_name,
            x: x,
            y: y,
            placeUrl: place_url,
            features: features
        )

        try container.encode(storeInfo, forKey: .storeInfoDto)

        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            try container.encode(imageUrl, forKey: .imageUrl)
        }

        try container.encodeIfPresent(bookmarkId, forKey: .bookmarkId)
        
        try container.encodeIfPresent(isInDBInfo, forKey: .isInDBInfo)
        

    }
}

struct IsInDBInfo: Codable {
    let totalHealthScore: Float
    let reviewCount: Int
    let sickScore: Float
    let sickCount: Int
    let vegetScore: Float
    let vegetCount: Int
    let dietScore: Float
    let dietCount: Int
}


// 검색 정보 모델
struct SearchInfo: Codable {
    let memberName: String
    let hasHealthInfo: Bool
    let query: String
    let baseX: String
    let baseY: String
    let radius: Int?
    let avgX: Double?
    let avgY: Double?
    let maxMeters: Double?
    let otherRegions: [String]
    let selectedRegion: String?
    let apiCallCount: Int
}
