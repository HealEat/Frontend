// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum StoreAPI {
    case getStoreDetail(storeId: Int)
    case saveStore(param: StoreSaveRequest)
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
        case .getStoreDetail(let storeId):
            return "/stores/\(storeId)"
        case .saveStore(let param):
            return "/stores/\(param.placeId)"
        case .getReview(let param):
            return "/stores/\(param.storeId)/reviews"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStoreDetail:
            return .get
        case .saveStore:
            return . post
        case .getReview:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getStoreDetail:
            return .requestPlain
        case .saveStore(let param):
            return .requestJSONEncodable(param)
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
