// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import Combine
import CombineMoya

class StoreRepository {
    static let shared = StoreRepository()
    
    private init() { }
    
    private let provider = APIManager.StoreProvider
    
    func saveStore(saveStoreRequest: SaveStoreRequest) -> AnyPublisher<SaveStoreResponseModel, HealEatError> {
        return provider.requestPublisher(.saveStore(param: saveStoreRequest))
            .extractResult(SaveStoreResponseEntity.self)
            .map({ SaveStoreResponseModel(saveStoreResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getStoreDetail(storeId: Int) -> AnyPublisher<StoreDetailResponseModel, HealEatError> {
        return provider.requestPublisher(.getStoreDetail(storeId: storeId))
            .extractResult(StoreDetailResponseEntity.self)
            .map({ StoreDetailResponseModel(storeDetailResponseEntity: $0) })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
