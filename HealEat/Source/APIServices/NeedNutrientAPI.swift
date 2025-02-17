







import Foundation
import Moya

enum NeedNutrientAPI {
    case sendNutrientPreference(selectedAnswers: [String])
}

extension NeedNutrientAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .sendNutrientPreference:
            return "/info/3"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case .sendNutrientPreference(let selectedAnswers):
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
