// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum MyPageAPI {
    case getProfile
    case changeProfile(name: String, image: Data?)
    
    case changeAnswer(questionNum: Int, param: HealthInfoAnswerRequest)
    case changeVegetarian(vegetarian: String)
    case changeDiet(diet: String)
    
    case getReview
    case getHealthInfo
    
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
        case .getProfile: return "my-page/profile"
        case .changeProfile: return "my-page/profile"
            
        case .changeAnswer(let questionNum, _):
            return "my-page/health-info\(questionNum)"
        case .changeVegetarian: return "my-page/health-info/veget"
        case .changeDiet: return "my-page/health-info/diet"
            
        case .getReview: return "my-page/reviews"
        case .getHealthInfo: return "my-page/health-info"
            
        case .deleteReview(let reviewId): return "my-page/reviews/\(reviewId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfile, .getReview, .getHealthInfo:
            return .get
        case .changeProfile, .changeAnswer, .changeVegetarian, .changeDiet:
            return .patch
        case .deleteReview:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .getProfile, .getReview, .getHealthInfo :
            return .requestPlain
            
            
            
        case .changeProfile(let name, let image):
            var multipartData: [MultipartFormData] = []
            // 닉네임 JSON 데이터 추가
            if let jsonData = try? JSONSerialization.data(withJSONObject: ["name": name], options: []) {
                multipartData.append(MultipartFormData(provider: .data(jsonData), name: "request"))
            }
            // 이미지 파일 추가
            if let imageData = image {
                multipartData.append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "profile.jpg", mimeType: "image/jpeg"))
            }
            return .uploadMultipart(multipartData)
        case .changeAnswer(_, let param) :
            return .requestJSONEncodable(param)
        case .changeVegetarian(let vegetarian) :
            return .requestParameters(parameters: ["vegetarian": vegetarian], encoding: URLEncoding.queryString)
        case .changeDiet(let diet) :
            return .requestParameters(parameters: ["diet": diet], encoding: URLEncoding.queryString)
        case .deleteReview :
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
