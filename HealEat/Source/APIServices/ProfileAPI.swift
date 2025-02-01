import Moya
import Foundation

enum ProfileAPI {
    case postProfile(param: ProfileRequest) // 프로필 저장 API
    case checkNickname(nickname: String) // 닉네임 중복 확인 API
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")! // ✅ 실제 API URL
    }

    var path: String {
        switch self {
        case .postProfile:
            return "/info/profile"
        case .checkNickname:
            return "/info/check-nickname"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postProfile:
            return .post
        case .checkNickname:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .postProfile(let param):
            return .requestJSONEncodable(param)

        case .checkNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer 9999" // ✅ 인증 토큰 (임시 값, 실제 토큰 사용)
        ]
    }
}
