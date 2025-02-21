// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum InfoAPI {
    case postInfo(questionNum: Int, param: InfoAnswerRequest)
    case postProfile(param: InfoProfileRequest)
    case searchDisease(keyword: String)
    case postDisease(param: DiseaseRequest)
    case loadInfo
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
        case .loadInfo: return "info/loading"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postInfo, .postProfile:
            return .post
        case .searchDisease:
            return .get
        case .postDisease, .loadInfo:
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
        case .loadInfo:
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
