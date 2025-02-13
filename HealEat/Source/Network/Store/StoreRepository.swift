// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import Combine
import CombineMoya

class StoreRepository {
    static let shared = StoreRepository()
    
    private init() { }
    
    private let provider = APIManager.StoreProvider
    
    func getReviews(reviewsRequest: ReviewsRequest) -> AnyPublisher<ReviewsResponseModel, HealEatError> {
        return provider.requestPublisher(.getReviews(param: reviewsRequest))
            .extractResult(ReviewsResponseEntity.self)
            .map({ ReviewsResponseModel(reviewsResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postBookmark(placeId: Int) -> AnyPublisher<BookmarkResponseModel, HealEatError> {
        return provider.requestPublisher(.postBookmark(placeId: placeId))
            .extractResult(BookmarkResponseEntity.self)
            .map({ BookmarkResponseModel(bookmarkResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
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
    
    func deleteBookmark(placeId: Int, bookmarkId: Int) -> AnyPublisher<BookmarkResponseModel, HealEatError> {
        return provider.requestPublisher(.deleteBookmark(placeId: placeId, bookmarkId: bookmarkId))
            .extractResult(BookmarkResponseEntity.self)
            .map({ BookmarkResponseModel(bookmarkResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
