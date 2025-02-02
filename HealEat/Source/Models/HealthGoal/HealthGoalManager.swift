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
    

    
    static func uploadImage(planId: Int, images: [UIImage], completion: @escaping (Bool) -> Void) {
        var multipartData = [MultipartFormData]()
        let jsonData = UploadHGImages(imageType: "health-plans", imageExtension: "jpg")
        if let infoData = MultipartForm.createJSONMultipartData(data: jsonData, fieldName: "info") {
            multipartData.append(infoData)
        }
        if let imageData = MultipartForm.createMultiImageMultipartData(images: images, fieldName: "image") {
            multipartData.append(imageData)
        }
        
        APIManager.HealthGoalProvider.request(.uploadImage(planId: planId, param: multipartData)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    //                    Toaster.shared.makeToast("회원가입이 성공적으로 완료되었습니다.")
                    completion(true)
                } else {
                    //                    Toaster.shared.makeToast("데이터를 불러오는 데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("이미지 업로드 요청 중 오류가 발생했습니다.")
                completion(false)
            }
        }
    }
    

    
    
    
}



