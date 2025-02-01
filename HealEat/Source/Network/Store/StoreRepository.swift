// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import Combine
import CombineMoya

class StoreRepository {
    static let shared = StoreRepository()
    
    private init() { }
    
    private let provider = APIManager.StoreProvider
    
    func saveStore(saveStoreRequest: SaveStoreRequest) -> AnyPublisher<DefaultResponse<SaveStoreResponseModel>, MoyaError> {
        return provider.requestPublisher(.saveStore(param: saveStoreRequest))
            .map(DefaultResponse<SaveStoreResponseEntity>.self)
            .map({ responseEntity in
                return DefaultResponse<SaveStoreResponseModel>(
                    isSuccess: responseEntity.isSuccess,
                    code: responseEntity.code,
                    message: responseEntity.message,
                    result: SaveStoreResponseModel(saveStoreResponseEntity: responseEntity.result)
                )
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
