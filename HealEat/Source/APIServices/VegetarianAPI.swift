// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum VegetarianAPI {
    case updateVegetarian(type: String)
}

extension VegetarianAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .updateVegetarian:
            return "/info/veget"
        }
    }

    var method: Moya.Method {
        switch self {
        case .updateVegetarian:
            return .patch  // ✅ PATCH 요청 사용
        }
    }

    var task: Task {
        switch self {
        case let .updateVegetarian(type):
            let params: [String: Any] = ["vegetarian": type]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
