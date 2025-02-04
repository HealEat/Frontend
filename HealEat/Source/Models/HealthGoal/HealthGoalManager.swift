// Copyright © 2025 HealEat. All rights reserved.

import Moya
import SwiftyToaster
import UIKit

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
    
    static func changeHealthGoal(_ userParameter: HealthGoalRequest, planId: Int,  completion: @escaping (Bool, Response?) -> Void ) {
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
    
    static func uploadImage(planId: Int, image: UIImage) {
        APIManager.HealthGoalProvider.request(.uploadImage(planId: planId, image: image, imageType: "profile", imageExtension: "jpg")) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON() {
                    print("✅ 업로드 성공: \(json)")
                } else {
                    print("❌ JSON 파싱 실패")
                }
            case .failure(let error):
                print("❌ 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
}



