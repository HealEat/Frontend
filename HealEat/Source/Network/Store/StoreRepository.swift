// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import Combine
import CombineMoya

class StoreRepository {
    static let shared = StoreRepository()
    
    private init() { }
    
    private let provider = APIManager.StoreProvider
    
    func getStoreDetail(placeId: Int) -> AnyPublisher<StoreDetailResponseModel, HealEatError> {
        return provider.requestPublisher(.getStoreDetail(placeId: placeId))
            .extractResult(StoreDetailResponseEntity.self)
            .map({ StoreDetailResponseModel(storeDetailResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getReviewImgs(placeId: Int, page: Int) -> AnyPublisher<ReviewImagesResponseModel, HealEatError> {
        return provider.requestPublisher(.getReviewImgs(placeId: placeId, page: page))
            .extractResult(ReviewImagesResponseEntity.self)
            .map({ ReviewImagesResponseModel(reviewImagesResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDaumImgs(placeId: Int) -> AnyPublisher<[DaumImageResponseModel], HealEatError> {
        return provider.requestPublisher(.getDaumImgs(placeId: placeId))
            .extractResult([DaumImageResponseEntity].self)
            .map({ daumImageResponseEntities in
                daumImageResponseEntities.map({ DaumImageResponseModel(daumImageResponseEntity: $0) })
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getReview(reviewGetRequest: ReviewGetRequest) -> AnyPublisher<ReviewGetResponseModel, HealEatError> {
        return provider.requestPublisher(.getReview(param: reviewGetRequest))
            .extractResult(ReviewGetResponseEntity.self)
            .map({ ReviewGetResponseModel(reviewGetResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
