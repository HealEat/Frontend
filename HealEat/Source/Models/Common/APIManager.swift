//
//  APIManager.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//
// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

class APIManager {
    static let HomeProvider = MoyaProvider<HomeAPI>(plugins: [NetworkLoggerPlugin()])
    static let CSearchProvider = MoyaProvider<CSearchAPI>(plugins: [NetworkLoggerPlugin()])
    static let HealthGoalProvider = MoyaProvider<HealthGoalAPI>(plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose, .requestBody, .requestHeaders, .successResponseBody, .errorResponseBody])) // ✅ 모든 로그 활성화!
    ])
    static let InfoProvider = MoyaProvider<InfoAPI>(plugins: [NetworkLoggerPlugin()])
    static let MyPageProvider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin()])
    static let StoreProvider = MoyaProvider<StoreAPI>(plugins: [NetworkLoggerPlugin()])
}
