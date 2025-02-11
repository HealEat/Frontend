// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct ImageModel {
    enum ImageType {
        case review
        case daum
    }
    struct Info: Codable {
        let name: String
        let url: URL?
        let currentPurposes: [String]
        
        init(reviewInfo: ReviewImagesResponseModel.ReviewImageDto.ReviewerInfo) {
            self.name = reviewInfo.name
            self.url = reviewInfo.profileImageUrl
            self.currentPurposes = reviewInfo.currentPurposes
        }
        
        init(daumInfo: DaumImageResponseModel) {
            self.name = daumInfo.display_sitename
            self.url = daumInfo.doc_url
            self.currentPurposes = []
        }
    }
    let type: ImageType
    let reviewId: Int
    let imageUrl: URL?
    let info: Info
    var size: CGSize?
    
    init(reviewImage: ReviewImagesResponseModel.ReviewImageDto) {
        self.type = .review
        self.reviewId = reviewImage.reviewId
        self.imageUrl = reviewImage.imageUrl
        self.info = Info(reviewInfo: reviewImage.reviewerInfo)
    }
    
    init(daumImage: DaumImageResponseModel) {
        self.type = .daum
        self.reviewId = 0
        self.imageUrl = daumImage.image_url
        self.info = Info(daumInfo: daumImage)
        self.size = CGSize(width: daumImage.width, height: daumImage.height)
    }
}
