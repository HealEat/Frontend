// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit
import KeychainSwift


enum AuthAPI {
    case logout
    case naverUnlink
    case kakaoUnlink
    
    case getTerms
    case agreeToTerms(param: TermsRequest)
    case getTermStatus
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .logout: return "auth/logout"
        case .naverUnlink: return "auth/naver/unlink"
        case .kakaoUnlink: return "auth/kakao/unlink"
            
        case .getTerms: return "terms"
        case .agreeToTerms(_): return "terms/agree"
        case .getTermStatus: return "terms/status"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout, .naverUnlink, .kakaoUnlink:
            return .post
        case .getTerms, .getTermStatus:
            return .get
        case .agreeToTerms:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logout:
            return .requestPlain
        case .getTerms, .getTermStatus:
            return .requestPlain
        case .agreeToTerms(let param):
            return .requestJSONEncodable(param)
        case .naverUnlink, .kakaoUnlink:
            var parameters: [String: Any] = [:]
            if let token = KeychainSwift().get("accessToken") {
                parameters["Authorization"] = token
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
}
