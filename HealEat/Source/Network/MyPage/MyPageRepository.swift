// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import Combine
import CombineMoya

class MyPageRepository {
    static let shared = MyPageRepository()
    
    private init() { }
    
    private let provider = APIManager.MyPageProvider
    
//    func getBookmarks(page: Int) -> AnyPublisher<ReviewsResponseModel, HealEatError> {
//        
//    }
}
