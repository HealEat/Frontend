// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum InfoAPI {
    case postInfo(questionNum: Int, param: InfoAnswerRequest)
    case postProfile(param: InfoProfileRequest)
    case searchDisease(keyword: String)
    case postDisease(param: DiseaseRequest)
}



extension InfoAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invralid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .postInfo(let questionNum, let param): return "info/\(questionNum)"
        case .postProfile(_): return "info/profile"
        case .searchDisease: return "info/disease/search"
        case .postDisease: return "info/member/disease"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postInfo, .postProfile:
            return .post
        case .searchDisease:
            return .get
        case .postDisease:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .postInfo(let questionNum, let param) :
            return .requestJSONEncodable(param)
        case .postProfile(let param):
            return .requestJSONEncodable(param)
        case .searchDisease(let keyword):
            return .requestParameters(parameters: [
                "keyword": keyword
            ], encoding: URLEncoding.queryString)
        case .postDisease(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
