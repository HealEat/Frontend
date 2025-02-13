// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

/// Store-Controller API
enum StoreAPI {
    case getReviews(param: ReviewsRequest)
    case postReview(placeId: Int)
    case postBookmark(placeId: Int)
    case getStoreDetail(placeId: Int)
    case getReviewImgs(placeId: Int, page: Int)
    case getDaumImgs(placeId: Int)
    case deleteBookmark(placeId: Int, bookmarkId: Int)
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
        case .getReviews(let param):
            return "/stores/\(param.placeId)/reviews"
        case .postReview(placeId: let placeId):
            return "/stores/\(placeId)/reviews"
        case .postBookmark(placeId: let placeId):
            return "/stores/\(placeId)/bookmarks"
        case .getStoreDetail(let placeId):
            return "/stores/\(placeId)"
        case .getReviewImgs(let placeId, let page):
            return "/stores/\(placeId)/reviewImgs"
        case .getDaumImgs(let placeId):
            return "/stores/\(placeId)/daumImgs"
        case .deleteBookmark(let placeId, let bookmarkId):
            return "/stores/\(placeId)/bookmarks/\(bookmarkId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStoreDetail, .getReviewImgs, .getDaumImgs, .getReviews:
            return .get
        case .postReview, .postBookmark:
            return .post
        case .deleteBookmark:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getStoreDetail, .getDaumImgs, .postBookmark, .deleteBookmark:
            return .requestPlain
        case .getReviewImgs(let placeId, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getReviews(let param):
            return .requestParameters(parameters: [
                "page": param.page,
                "sortBy": param.sortBy.rawValue,
                "filters": param.filters.map({ $0.rawValue }),
            ], encoding: URLEncoding.queryString)
        case .postReview:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
