// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit


enum CSearchAPI {
    case search(page: Int, param: CSearchRequest)
    case searchStore(placeId: Int)
    case searchRecent(page: Int)
    case deleteRecentSearch(recentId: Int)
}



extension CSearchAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .search(let page, let param): return "search"
        case .searchStore(let placeId): return "search/\(placeId)"
        case .searchRecent: return "search/recent"
        case .deleteRecentSearch(let recentId): return "search/recent/\(recentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        case .searchStore:
            return .post
        case .searchRecent:
            return .get
        case .deleteRecentSearch:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .search(let page, let param):
            let queryParam: [String: Any] = ["page": page]
            guard let bodyParams = param.toDictionary() else {
                return .requestPlain
            }
            return .requestCompositeParameters(
                bodyParameters: bodyParams,
                bodyEncoding: JSONEncoding.default,
                urlParameters: queryParam)
            
        case .searchStore:
            return .requestPlain
            
        case .searchRecent(let page):
            let queryParam: [String: Any] = ["page": page]
            
            return .requestParameters(parameters: queryParam, encoding: URLEncoding.default)
            
        case .deleteRecentSearch(let recentId):
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
}
