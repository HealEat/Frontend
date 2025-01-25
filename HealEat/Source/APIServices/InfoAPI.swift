// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum InfoAPI {
    case postInfo(param: Int)
}



extension InfoAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .postInfo(let param): return "info"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postInfo:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .postInfo(let param) :
            return .requestJSONEncodable(param)
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
