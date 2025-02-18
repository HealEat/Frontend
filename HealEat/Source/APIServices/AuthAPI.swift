// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import UIKit


enum AuthAPI {
    case logout
    case naverUnlink
    case kakaoUnlink
    
    case getTerms
    case agreeToTerms
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
        case .agreeToTerms: return "terms/agree"
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
        case .logout, .naverUnlink, .kakaoUnlink:
            return .requestPlain
        case .getTerms, .agreeToTerms, .getTermStatus:
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
