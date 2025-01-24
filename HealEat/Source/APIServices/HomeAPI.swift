// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum HomeAPI {
    case getStores(param: Int) // Int 타입 대신 좌표를 저장하는 struct 따로 만들어야 합니다
}



extension HomeAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getStores(let param): return "home"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStores:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getStores(let param) :
            return .requestJSONEncodable(param)
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
