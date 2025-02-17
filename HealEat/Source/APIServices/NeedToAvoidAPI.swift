







import Moya
import Foundation

enum NeedToAvoidAPI {
    case sendAvoidancePreference(selectedAnswers: [String])
}

extension NeedToAvoidAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .sendAvoidancePreference:
            return "/info/4"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case .sendAvoidancePreference(let selectedAnswers):
            let parameters: [String: Any] = ["selectedAnswers": selectedAnswers]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "accept": "*/*",
            "Authorization": "Bearer 9999",
            "Content-Type": "application/json"
        ]
    }
}
