// Copyright © 2025 HealEat. All rights reserved.

import Moya
import SwiftyToaster
import UIKit

class HealthGoalManager {
    static func getHealthGoals(page: Int, completion: @escaping (Result<DefaultResponse<HealthGoalResponse> , Error>) -> Void) {
        APIManager.HealthGoalProvider.request(.getHealthGoal(page: page)) {
            result in
            switch result {
            case .success(let response):
                do {
                    let goalResult = try response.map(DefaultResponse<HealthGoalResponse>.self)
                     print("success")
                    completion(.success(goalResult))
                } catch {
                    //print(response)
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
    
    static func deleteHealthGoal(_ planId: Int, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.HealthGoalProvider.request(.deleteHealthGoal(planId: planId)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("건강 목표 삭제 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func changeHealthGoal(_ userParameter: ChangeHealthGoalRequest, planId: Int,  completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.HealthGoalProvider.request(.changeHealthGoal(planId: planId, param: userParameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("건강 목표 수정 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func uploadHealthGoalStatus(planId: Int, status: String, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.HealthGoalProvider.request(.uploadStatus(planId: planId, status: status)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("진행 상황 업로드 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func uploadHealthGoalMemo(planId: Int, memo: String, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.HealthGoalProvider.request(.uploadMemo(planId: planId, memo: memo)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("메모 업로드 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    

    
    
    
}



