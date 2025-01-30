// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum MyPageAPI {
    case getMyPage
    case getReview
    case getHealthInfo
    case changeMyPage(param: HealthGoalRequest) // 수정 필요
    case deleteReview(reviewId: Int)
}



extension MyPageAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getMyPage: return "my-page"
        case .getReview: return "my-page/reviews"
        case .getHealthInfo: return "my-page/health-info"
            
        case .changeMyPage(let param): return "my-page"
            
        case .deleteReview(let reviewId): return "my-page/reviews/\(reviewId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMyPage, .getReview, .getHealthInfo:
            return .get
        case .changeMyPage:
            return .patch
        case .deleteReview:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .getMyPage, .getReview, .getHealthInfo :
            return .requestPlain
        case .changeMyPage(let param) :
            return .requestJSONEncodable(param)
        case .deleteReview :
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
