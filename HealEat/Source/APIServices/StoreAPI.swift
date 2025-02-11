// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum StoreAPI {
    case getStoreDetail(placeId: Int)
    case getReviewImgs(placeId: Int, page: Int)
    case getDaumImgs(placeId: Int)
    case getReview(param: ReviewGetRequest)
//    case postBookmark(storeId: Int)
//    case deleteBookmark(storeId: Int)
}

extension StoreAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getStoreDetail(let placeId):
            return "/stores/\(placeId)"
        case .getReviewImgs(let placeId, let page):
            return "/stores/\(placeId)/reviewImgs"
        case .getDaumImgs(let placeId):
            return "/stores/\(placeId)/daumImgs"
        case .getReview(let param):
            return "/stores/\(param.storeId)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStoreDetail, .getReviewImgs, .getDaumImgs:
            return .get
        case .getReview:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getStoreDetail, .getDaumImgs:
            return .requestPlain
        case .getReviewImgs(let placeId, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getReview(let param):
            return .requestParameters(parameters: [
                "page": param.page,
                "sort": param.sort.rawValue,
                "sortOrder": param.sortOrder.rawValue,
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
