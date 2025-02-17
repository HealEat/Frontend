



import Foundation
import Moya

enum GetNameAPI {
    case fetchUserName
}

extension GetNameAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .fetchUserName:
            return "/my-page/profile"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return ["Authorization": "Bearer 9999", "Accept": "*/*"]
    }
}
