//
//  APIManager.swift
//  HealEat
//
//  Created by 이태림 on 1/26/25.
//

import Foundation
import Moya

class APIManager {
    static let HomeProvider = MoyaProvider<HomeAPI>(plugins: [NetworkLoggerPlugin()])
}
