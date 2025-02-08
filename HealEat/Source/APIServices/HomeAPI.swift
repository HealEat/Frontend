//
//  HomeAPI.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//
// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

enum HomeAPI {
    case getStores(lat: Double, lon: Double, radius: Int, page: Int)
}

extension HomeAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .getStores:
            return "/home"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStores:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .getStores(let lat, let lon, let radius, let page):
            let parameters: [String: Any] = [
                "x": "\(lat)",
                "y": "\(lon)",
                "radius": 100
            ]
            let queryParameters: [String: Any] = ["page": page]
            
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: queryParameters
            )
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
    }
}
