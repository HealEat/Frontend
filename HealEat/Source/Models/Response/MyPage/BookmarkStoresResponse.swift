// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct BookmarkStoresResponseEntity: Codable {
    struct StoreList: Codable {
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
            let totalHealthScore: Float?
            let reviewCount: Int?
            let sickScore: Float?
            let sickCount: Int?
            let vegetScore: Float?
            let vegetCount: Int?
            let dietScore: Float?
            let dietCount: Int?
        }
        let storeInfoDto: StoreInfoDto?
        let imageUrl: String?
        let bookmarkId: Int?
    }
    
    struct SearchInfoDto: Codable {
        let memberName: String?
        let hasHealthInfo: Bool?
        let rect: String?
        let query: String?
        let baseX: String?
        let baseY: String?
        let radius: Int?
        let avgX: Double?
        let avgY: Double?
        let maxMeters: Double?
        let otherRegions: [String]?
        let selectedRegion: String?
        let apiCallCount: Int?
    }
    
    let storeList: [StoreList]?
    let listSize: Int?
    let totalPage: Int?
    let totalElements: Int?
    let isFirst: Bool?
    let isLast: Bool?
    let searchInfoDto: SearchInfoDto?
}

struct BookmarkStoresResponseModel: Codable {
    struct StoreList: Codable {
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
            let totalHealthScore: Float?
            let reviewCount: Int?
            let sickScore: Float?
            let sickCount: Int?
            let vegetScore: Float?
            let vegetCount: Int?
            let dietScore: Float?
            let dietCount: Int?
        }
        let storeInfoDto: StoreInfoDto?
        let imageUrl: String?
        let bookmarkId: Int?
    }
    
    struct SearchInfoDto: Codable {
        let memberName: String?
        let hasHealthInfo: Bool?
        let rect: String?
        let query: String?
        let baseX: String?
        let baseY: String?
        let radius: Int?
        let avgX: Double?
        let avgY: Double?
        let maxMeters: Double?
        let otherRegions: [String]?
        let selectedRegion: String?
        let apiCallCount: Int?
    }
    
    let storeList: [StoreList]?
    let listSize: Int?
    let totalPage: Int?
    let totalElements: Int?
    let isFirst: Bool?
    let isLast: Bool?
    let searchInfoDto: SearchInfoDto?
}
