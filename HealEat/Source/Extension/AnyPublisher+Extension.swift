// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Combine
import CombineMoya
import Moya

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    // 서버로부터 받아온 결과값을 DefaultResponse<D>로 변환 후,
    // result값을 D 타입으로 return 또는 HealEatError를 throw
    func extractResult<D: Codable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, HealEatError> {
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
