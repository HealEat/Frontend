// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit

/// Store-Controller API
enum StoreAPI {
    case getReviews(param: ReviewsRequest)
    case postReview(param: ReviewWriteRequest)
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
        case .postReview(let param):
            return "/stores/\(param.placeId)/reviews"
        case .postBookmark(let placeId):
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
                "filters": param.filters.map(\.rawValue),
            ], encoding: URLEncoding.queryString)
        case .postReview(let param):
            var multipartFormDatas: [MultipartFormData] = []
            let request: [String: Any] = [
                "healthScore": param.request.healthScore,
                "tastyScore": param.request.tastyScore,
                "cleanScore": param.request.cleanScore,
                "freshScore": param.request.freshScore,
                "nutrScore": param.request.nutrScore,
                "body": param.request.body,
            ]
            if let requestData = try? JSONSerialization.data(withJSONObject: request, options: []) {
                multipartFormDatas.append(MultipartFormData(provider: .data(requestData), name: "request"))
            }
            param.images.enumerated().forEach({ i, image in
                multipartFormDatas.append(MultipartFormData(provider: .data(image), name: "files", fileName: "\(i).png", mimeType: "image/png"))
            })
            print(multipartFormDatas)
            return .uploadMultipart(multipartFormDatas)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postReview:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
