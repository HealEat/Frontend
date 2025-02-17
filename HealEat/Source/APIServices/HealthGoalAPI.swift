// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit


enum HealthGoalAPI {
    case getHealthGoal(page: Int)
    case postHealthGoal(param: HealthGoalRequest)
    case deleteHealthGoal(planId: Int)
    case changeHealthGoal(planId: Int, param: ChangeHealthGoalRequest)
    
    case uploadStatus(planId: Int, status: String)
    case uploadMemo(planId: Int, memo: String)
}



extension HealthGoalAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getHealthGoal(let page): return "plans"
            
        case .postHealthGoal(let param): return "plans"
            
        case .deleteHealthGoal(let planId): return "plans/\(planId)"
        case .changeHealthGoal(let planId, let param): return "plans/\(planId)"
            
        case .uploadStatus(let planId, let status): 
            return "plans/\(planId)/status"
        case .uploadMemo(let planId, let memo):
            return "plans/\(planId)/memo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHealthGoal:
            return .get
        case .postHealthGoal:
            return .post
        case .deleteHealthGoal:
            return .delete
        case .changeHealthGoal:
            return .post
            
        case .uploadStatus:
            return .patch
        case .uploadMemo:
            return .patch
        }
    }

    
    var task: Moya.Task {
        switch self {
        case .getHealthGoal(let page) :
            let query: [String: Any] = ["page": page]
            return .requestParameters(parameters: query, encoding: URLEncoding.default)
            
        case .postHealthGoal(let param) :
            return .requestJSONEncodable(param)
            
        case .deleteHealthGoal :
            return .requestPlain
            
            
        case .changeHealthGoal(let planId, let param) :
            var multipartFormDatas: [MultipartFormData] = []
            if let requestData = try? JSONEncoder().encode(param.updateRequest) {
                multipartFormDatas.append(MultipartFormData(provider: .data(requestData), name: "updateRequest"))
            }
            param.images.enumerated().forEach({ i, image in
                multipartFormDatas.append(MultipartFormData(provider: .data(image), name: "files", fileName: "\(i).jpg", mimeType: "image/jpeg"))
            })
            print(multipartFormDatas)
            return .uploadMultipart(multipartFormDatas)
            
            
        case .uploadStatus(let planId, let status):
            let requestBody: [String: Any] = ["status": status]
            return .requestParameters(parameters: requestBody, encoding: JSONEncoding.default)
            
        case .uploadMemo(let planId, let memo):
            let requestBody: [String: Any] = ["memo": memo]
            return .requestParameters(parameters: requestBody, encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .changeHealthGoal:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
}
