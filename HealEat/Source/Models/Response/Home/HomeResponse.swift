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
    let distance: Double
    let imageUrlList: [String]
    let features: [String]
    let reviewCount: Int?
    let totalScore: Int?
    let isBookMarked: Bool

    enum CodingKeys: String, CodingKey {
        case storeInfoDto
        case storeImageListDto
        case isBookMarked = "bookmarkId"
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
        let distance: Double?
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
            self.distance = storeInfo.distance ?? 0.0
            self.features = storeInfo.features

            // 이미지 URL 가져오기
            if let imageList = try container.decodeIfPresent(StoreImageList.self, forKey: .storeImageListDto) {
                self.imageUrlList = imageList.daumImgDocuments.map { $0.image_url }
            } else {
                self.imageUrlList = []
            }

            let bookmarkId = try container.decodeIfPresent(Int?.self, forKey: .isBookMarked)
            self.isBookMarked = bookmarkId != nil
            // 🚀 아직 서버 응답에 없어서 기본값 설정
            self.reviewCount = 0
            self.totalScore = 0
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
                distance: distance,
                features: features
            )

            try container.encode(storeInfo, forKey: .storeInfoDto)

            let imageList = StoreImageList(daumImgDocuments: imageUrlList.map { ImageDocument(image_url: $0) })
            try container.encode(imageList, forKey: .storeImageListDto)
            if isBookMarked {
                try container.encode(1, forKey: .isBookMarked) // True일 때 1로 저장
            }
        }
}


// 검색 정보 모델
struct SearchInfo: Codable {
    let baseX: String
    let baseY: String
    let query: String
    let otherRegions: [String]
    let selectedRegion: String?
    let apiCallCount: Int
    let memberName: String?
}

