// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ReviewsResponseEntity: Codable {
    struct ReviewList: Codable {
        struct ReviewerInfo: Codable {
            let name: String?
            let profileImageUrl: String?
            let currentPurposes: [String]?
        }
        let reviewerInfo: ReviewerInfo?
        let reviewId: Int?
        let totalScore: Float?
        let imageUrls: [String]?
        let body: String?
        let createdAt: String?
    }
    let reviewList: [ReviewList]?
    let listSize: Int?
    let totalPage: Int?
    let totalElements: Int?
    let isFirst: Bool?
    let isLast: Bool?
}

struct ReviewsResponseModel: Codable {
    struct ReviewList: Codable {
        struct ReviewerInfo: Codable {
            let name: String
            let profileImageUrl: URL?
            let currentPurposes: [String]
            
            init(reviewerInfo: ReviewsResponseEntity.ReviewList.ReviewerInfo?) {
                self.name = reviewerInfo?.name ?? ""
                self.profileImageUrl = URL(string: reviewerInfo?.profileImageUrl ?? "")
                self.currentPurposes = reviewerInfo?.currentPurposes ?? []
            }
        }
        let reviewerInfo: ReviewerInfo
        let reviewId: Int
        let totalScore: Float
        let imageUrls: [URL]
        let body: String
        let createdAt: Date
        
        init(reviewList: ReviewsResponseEntity.ReviewList) {
            self.reviewerInfo = ReviewerInfo(reviewerInfo: reviewList.reviewerInfo)
            self.reviewId = reviewList.reviewId ?? 0
            self.totalScore = reviewList.totalScore ?? 0
            self.imageUrls = reviewList.imageUrls?.compactMap({ URL(string: $0) }) ?? []
            self.body = reviewList.body ?? ""
            self.createdAt = reviewList.createdAt?.convertISO8601ToDate() ?? Date()
            
        }
    }
    let reviewList: [ReviewList]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    
    init(reviewsResponseEntity: ReviewsResponseEntity) {
        self.reviewList = reviewsResponseEntity.reviewList?.map({ ReviewList(reviewList: $0) }) ?? []
        self.listSize = reviewsResponseEntity.listSize ?? 0
        self.totalPage = reviewsResponseEntity.totalPage ?? 0
        self.totalElements = reviewsResponseEntity.totalElements ?? 0
        self.isFirst = reviewsResponseEntity.isFirst ?? false
        self.isLast = reviewsResponseEntity.isLast ?? false
    }
}
