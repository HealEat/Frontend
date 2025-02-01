// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct StoreDetailResponseEntity: Codable {
    struct ReviewImagePreviewDtoList: Codable {
        struct ReviewerInfo: Codable {
            let name: String?
            let profileImageUrl: String?
            let currentPurposes: [String]?
        }
        
        let reviewId: Int?
        let reviewerInfo: ReviewerInfo?
        let firstImageUrl: String?
    }
    
    let reviewImagePreviewDtoList: [ReviewImagePreviewDtoList]?
    let daumImageUrls: [String]?
}

struct StoreDetailResponseModel: Codable {
    struct ReviewImagePreviewDtoList: Codable {
        struct ReviewerInfo: Codable {
            let name: String
            let profileImageUrl: URL?
            let currentPurposes: [String]
            
            init(reviewerInfo: StoreDetailResponseEntity.ReviewImagePreviewDtoList.ReviewerInfo?) {
                self.name = reviewerInfo?.name ?? ""
                self.profileImageUrl = URL(string: reviewerInfo?.profileImageUrl ?? "")
                self.currentPurposes = reviewerInfo?.currentPurposes ?? []
            }
        }
        
        let reviewId: Int
        let reviewerInfo: ReviewerInfo
        let firstImageUrl: URL?
        
        init(reviewImagePreviewDtoList: StoreDetailResponseEntity.ReviewImagePreviewDtoList) {
            self.reviewId = reviewImagePreviewDtoList.reviewId ?? 0
            self.reviewerInfo = ReviewerInfo(reviewerInfo: reviewImagePreviewDtoList.reviewerInfo)
            self.firstImageUrl = URL(string: reviewImagePreviewDtoList.firstImageUrl ?? "")
        }
    }
    
    let reviewImagePreviewDtoList: [ReviewImagePreviewDtoList]
    let daumImageUrls: [URL]
    
    init(storeDetailResponseEntity: StoreDetailResponseEntity) {
        self.reviewImagePreviewDtoList = storeDetailResponseEntity.reviewImagePreviewDtoList?.map({ ReviewImagePreviewDtoList(reviewImagePreviewDtoList: $0) }) ?? []
        self.daumImageUrls = storeDetailResponseEntity.daumImageUrls?.compactMap({ URL(string: $0) }) ?? []
    }
}
