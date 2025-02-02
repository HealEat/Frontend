// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit


enum HealthGoalAPI {
    case getHealthGoal
    case postHealthGoal(param: HealthGoalRequest)
    case deleteHealthGoal(planId: Int)
    case changeHealthGoal(planId: Int, param: HealthGoalRequest)
    case uploadImage(planId: Int, param: [MultipartFormData])
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
        case .getHealthGoal: return "plans"
            
        case .postHealthGoal(let param): return "plans"
            
        case .deleteHealthGoal(let planId): return "plans/\(planId)"
        case .changeHealthGoal(let planId, let param): return "plans/\(planId)"
            
        case .uploadImage(let planId): return "plans/\(planId)/upload-images"
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
            return .patch
            
        case .uploadImage:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getHealthGoal :
            return .requestPlain
        case .postHealthGoal(let param) :
            return .requestJSONEncodable(param)
        case .deleteHealthGoal :
            return .requestPlain
        case .changeHealthGoal(let planId, let param) :
            return .requestJSONEncodable(param)
            
            
        case .uploadImage(let planId, let param):
            return .uploadMultipart(param)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
}
