







import Moya
import Foundation

enum NeedDietAPI {
    case sendDietPreference(selectedAnswers: [String])
}

extension NeedDietAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .sendDietPreference:
            return "/info/2"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case .sendDietPreference(let selectedAnswers):
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
