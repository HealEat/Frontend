// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

public enum HealEatError: Error {
    case moyaError(error: MoyaError)
    case healeatError(statusCode: String, message: String)
    
    var description: String {
        switch self {
        case .moyaError(let error):
            return "Moya Error - \(error)"
        case .healeatError(let statusCode, let message):
            return "HealEat Error - Status Code: \(statusCode), Message: \(message)"
        }
    }
}
