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
    
    // TODO: Temp 삭제할 것!
    case testPostReview(param: ReviewWriteRequest)
}

extension StoreAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: GlobalConst.baseURL) else {
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
        case .testPostReview(let param):
            if let memberId = GlobalConst.memberId {
                return "/stores/\(param.placeId)/reviews/\(memberId)"
            }
            return "/stores/\(param.placeId)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStoreDetail, .getReviewImgs, .getDaumImgs, .getReviews:
            return .get
        case .postReview, .postBookmark, .testPostReview:
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
            if let requestData = try? JSONEncoder().encode(param.request) {
                multipartFormDatas.append(MultipartFormData(provider: .data(requestData), name: "request"))
            }
            param.images.enumerated().forEach({ i, image in
                multipartFormDatas.append(MultipartFormData(provider: .data(image), name: "files", fileName: "\(i).jpg", mimeType: "image/jpeg"))
            })
            print(multipartFormDatas)
            return .uploadMultipart(multipartFormDatas)
        case .testPostReview(let param):
            var multipartFormDatas: [MultipartFormData] = []
            if let requestData = try? JSONEncoder().encode(param.request) {
                multipartFormDatas.append(MultipartFormData(provider: .data(requestData), name: "request"))
            }
            param.images.enumerated().forEach({ i, image in
                multipartFormDatas.append(MultipartFormData(provider: .data(image), name: "files", fileName: "\(i).jpg", mimeType: "image/jpeg"))
            })
            print(multipartFormDatas)
            return .uploadMultipart(multipartFormDatas)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postReview, .testPostReview:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
