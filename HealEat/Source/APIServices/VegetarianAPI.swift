





import Foundation
import Moya

enum VegetarianAPI {
    case updateVegetarian(type: String)
}

extension VegetarianAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
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

    var headers: [String: String]? {
        return [
            "accept": "*/*",
            "Authorization": "Bearer 9999"
        ]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
