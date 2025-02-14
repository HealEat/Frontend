
import Foundation
import Moya

enum DietAPI {
    case updateDietType(type: String)
}

extension DietAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
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

    var headers: [String: String]? {
        return [
            "accept": "application/json",
            "Authorization": "Bearer 9999"
        ]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
