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
    

    
    static func uploadImage(planId: Int, images: [UIImage], completion: @escaping (Bool, String?) -> Void) {
        var multipartData = [MultipartFormData]()
        let files = MultipartForm.createMultiImageMultipartData(images: images, fieldName: "files")
        multipartData.append(contentsOf: files)
        
        let jsonData = UploadHGImages(imageType: "health-plans", imageExtension: "jpg")
        if let requests = MultipartForm.createJSONMultipartData(data: jsonData, fieldName: "requests") {
            multipartData.append(requests)
        }
        
        APIManager.HealthGoalProvider.request(.uploadImage(planId: planId, param: multipartData)) { result in
            APIManager.HealthGoalProvider.request(.uploadImage(planId: planId, param: multipartData)) { result in
                switch result {
                case .success(let response):
                    let responseData = response.data
                    let responseString = String(data: responseData, encoding: .utf8) ?? "응답 데이터 없음"
                    print("🔴 서버 응답 메시지: \(responseString)")  // ✅ 서버에서 준 에러 메시지 확인

                    if response.statusCode == 200 {
                        completion(true, nil)
                    } else {
                        print("🎨 이미지 업로드 코드 200이 아님")
                        completion(false, responseString)  // ✅ 오류 메시지를 클라이언트에서도 확인
                    }
                case .failure(let error):
                    print("🔴 이미지 업로드 실패: \(error.localizedDescription)")
                }
            }

        }
    }
    

    
    
    
}



