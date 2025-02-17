














import Foundation
import Moya

enum DiseaseServiceAPI {
    case searchDisease(keyword: String)
    case updateDisease(diseaseName: String)
    case addDisease(diseaseName: String)  // ✅ 추가됨
}

extension DiseaseServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .searchDisease:
            return "/info/disease/search"
        case .updateDisease:
            return "/info/member/disease"
        case .addDisease:
            return "/info/member/disease"  // ✅ 추가됨
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchDisease:
            return .get
        case .updateDisease, .addDisease:
            return .patch  // ✅ `addDisease`도 PATCH 사용
        }
    }

    var task: Task {
        switch self {
        case .searchDisease(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.default)
        case .updateDisease(let diseaseName), .addDisease(let diseaseName):  // ✅ 추가됨
            return .requestJSONEncodable(["diseaseName": diseaseName])
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
