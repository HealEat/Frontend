// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Kingfisher
import Combine

class ImageModel {
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        setSize()
    }
    
    init(daumImage: DaumImageResponseModel) {
        self.type = .daum
        self.reviewId = 0
        self.imageUrl = daumImage.image_url
        self.info = Info(daumInfo: daumImage)
        setSize()
    }
    
    private func getImageSize(url: URL) -> Future<CGSize, KingfisherError> {
        return Future<CGSize, KingfisherError> { promise in
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: { result in
                switch result {
                case .success(let value):
                    promise(.success(value.image.size))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
    }
    
    private func setSize() {
        guard let imageUrl = self.imageUrl else { return }
        getImageSize(url: imageUrl)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] size in
                self?.size = size
            })
            .store(in: &cancellable)
    }
}
