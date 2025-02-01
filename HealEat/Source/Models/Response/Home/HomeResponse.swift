//
//  HomeResponse.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//

import Foundation

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
    let distance: String
    let imageUrlList: [String]
    let features: [String]
    let reviewCount: Int
    let totalScore: Int
    let sickScore: Int
    let vegetScore: Int
    let dietScore: Int
    let isBookMarked: Bool
}

struct HomeResponse: Codable {
    let storeList: [StoreResponse]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    let searchInfo: SearchInfo
}

struct SearchInfo: Codable {
    let baseX: String
    let baseY: String
    let query: String
    let otherRegions: [String]
    let selectedRegion: String
    let apiCallCount: Int
}
