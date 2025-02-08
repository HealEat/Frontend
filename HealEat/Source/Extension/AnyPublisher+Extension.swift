// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Combine
import CombineMoya
import Moya

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    func HEmap<D: Codable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, HealEatError> {
        return map(DefaultResponse<D>.self)
            .tryMap({ defaultResponse in
                if !defaultResponse.isSuccess {
                    throw HealEatError.healeatError(statusCode: defaultResponse.code, message: defaultResponse.message)
                }
                guard let result = defaultResponse.result else {
                    throw HealEatError.resultNil(statusCode: defaultResponse.code, message: defaultResponse.message)
                }
                return result
            })
            .mapError({ error in
                if let error = error as? MoyaError {
                    return HealEatError.moyaError(error: error)
                }
                return error as! HealEatError
            })
            .eraseToAnyPublisher()
    }
}
