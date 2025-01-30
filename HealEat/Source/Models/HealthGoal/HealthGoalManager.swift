// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import SwiftyToaster

class HealthGoalManager {
    static func getHealthGoals(completion: @escaping (Result<DefaultResponse<HealthGoalResponse> , Error>) -> Void) {
        APIManager.HealthGoalProvider.request(.getHealthGoal) {
            result in
            switch result {
            case .success(let response):
                do {
                    let goalResult = try response.map(DefaultResponse<HealthGoalResponse>.self)
                     print("success")
                    completion(.success(goalResult))
                } catch {
                    print(response)
                    //print("mapping error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                Toaster.shared.makeToast("건강 목표 불러오기 중 에러가 발생했습니다.")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }
    
    static func postHealthGoal(_ userParameter: HealthGoalRequest, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.HealthGoalProvider.request(.postHealthGoal(param: userParameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("건강 목표 저장 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    
    
}



