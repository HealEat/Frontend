// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum ReviewAPI {
    case getReview(storeId: Int)
    case postReview(storeId: Int)
    case getReviewImage(storeId: Int)
}



extension ReviewAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getReview(let storeId): return "stores/\(storeId)/reviews"
            
        case .postReview(let storeId): return "stores/\(storeId)/reviews"
            
        case .getReviewImage(let storeId): return "stores/\(storeId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getReview, .getReviewImage:
            return .get
        case .postReview:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .getReview, .getReviewImage:
            return .requestPlain
        case .postReview(let param) : // storeId도 동시에 같이 보내도록 수정해야 합니다
            return .requestJSONEncodable(param)
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
