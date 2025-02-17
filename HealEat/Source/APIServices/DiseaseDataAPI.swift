
















import Moya
import Foundation

enum DiseaseAPI {
    case searchDisease(keyword: String)
}

extension DiseaseAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .searchDisease:
            return "/info/disease/search"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .searchDisease(keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return [
            "accept": "*/*",
            "Authorization": "Bearer 9999"
        ]
    }
}
