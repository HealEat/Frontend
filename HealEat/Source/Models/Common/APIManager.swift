// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

class APIManager {
    static let AuthProvider = MoyaProvider<AuthAPI>(plugins:
    [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let HomeProvider = MoyaProvider<HomeAPI>(plugins:
    [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let CSearchProvider = MoyaProvider<CSearchAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let HealthGoalProvider = MoyaProvider<HealthGoalAPI>(plugins:
        [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let InfoProvider = MoyaProvider<InfoAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let MyPageProvider = MoyaProvider<MyPageAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    static let StoreProvider = MoyaProvider<StoreAPI>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
}

