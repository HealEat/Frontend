// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ReviewResponse: Codable {
    let myPageReviewList: [MyReview]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

struct MyReview: Codable {
    let storeId: Int
    let storeName: String
    let storeImage: String
    let storeCategory: String
    let storeTotalScore: Int
    let reviewPreview: ReviewPreview
}

struct ReviewPreview: Codable {
    let reviewerInfo: ReviewerInfo
    let reviewId: Int
    let totalScore: Int
    let imageUrls: [String]
    let body: String
    let createdAt: String
}

struct ReviewerInfo: Codable {
    let name: String
    let profileImageUrl: String
    let currentPurposes: [String]
}
