// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum StoreAPI {
    case getStoreDetail(storeId: Int)
    case saveStore(param: SaveStoreRequest)
//    case getReview(storeId: Int)
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
//        case .postBookmark(let storeId):
//            return "/stores/\(storeId)/bookmarks"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStoreDetail:
            return .get
        case .saveStore:
            return . post
        }
    }

    var task: Moya.Task {
        switch self {
        case .getStoreDetail:
            return .requestPlain
        case .saveStore(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
