










import Foundation
import Moya

enum DiseaseQuestionAPI {
    case sendOptions(selectedAnswers: [String])
}

extension DiseaseQuestionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .sendOptions:
            return "/info/1"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sendOptions:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .sendOptions(let selectedAnswers):
            let parameters: [String: Any] = ["selectedAnswers": selectedAnswers]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "Authorization": "Bearer 9999",
            "Content-Type": "application/json"
        ]
    }
}
