// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ReviewImagesResponseEntity: Codable {
    struct ReviewImageDto: Codable {
        struct ReviewerInfo: Codable {
            let name: String?
            let profileImageUrl: String?
            let currentPurposes: [String]?
        }
        let reviewId: Int?
        let imageUrl: String?
        let reviewerInfo: ReviewerInfo?
    }
    let reviewImageDtoList: [ReviewImageDto]?
    let listSize: Int?
    let totalPage: Int?
    let totalElements: Int?
    let isFirst: Bool?
    let isLast: Bool?
}

struct ReviewImagesResponseModel: Codable {
    struct ReviewImageDto: Codable {
        struct ReviewerInfo: Codable {
            let name: String
            let profileImageUrl: URL?
            let currentPurposes: [String]
            
            init(reviewerInfo: ReviewImagesResponseEntity.ReviewImageDto.ReviewerInfo?) {
                self.name = reviewerInfo?.name ?? ""
                self.profileImageUrl = URL(string: reviewerInfo?.profileImageUrl ?? "")
                self.currentPurposes = reviewerInfo?.currentPurposes ?? []
            }
        }
        let reviewId: Int
        let imageUrl: URL?
        let reviewerInfo: ReviewerInfo
        
        init(reviewImageDto: ReviewImagesResponseEntity.ReviewImageDto?) {
            self.reviewId = reviewImageDto?.reviewId ?? 0
            self.imageUrl = URL(string: reviewImageDto?.imageUrl ?? "")
            self.reviewerInfo = ReviewerInfo(reviewerInfo: reviewImageDto?.reviewerInfo)
        }
    }
    let reviewImageDtoList: [ReviewImageDto]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    
    init(reviewImagesResponseEntity: ReviewImagesResponseEntity) {
        self.reviewImageDtoList = reviewImagesResponseEntity.reviewImageDtoList?.map({ ReviewImageDto(reviewImageDto: $0) }) ?? []
        self.listSize = reviewImagesResponseEntity.listSize ?? 0
        self.totalPage = reviewImagesResponseEntity.totalPage ?? 0
        self.totalElements = reviewImagesResponseEntity.totalElements ?? 0
        self.isFirst = reviewImagesResponseEntity.isFirst ?? false
        self.isLast = reviewImagesResponseEntity.isLast ?? false
    }
}
