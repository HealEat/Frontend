// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum DietAPI {
    case updateDietType(type: String)
}

extension DietAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        return "/info/diet"
    }

    var method: Moya.Method {
        return .patch
    }

    var task: Task {
        switch self {
        case let .updateDietType(type):
            let params: [String: Any] = ["diet": type]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
        
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
