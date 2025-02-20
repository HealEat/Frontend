// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import SwiftyToaster

class MyPageManager {
    static func getProfile(completion: @escaping (Result<DefaultResponse<MyProfileResponse> , Error>) -> Void) {
        APIManager.MyPageProvider.request(.getProfile) {
            result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DefaultResponse<MyProfileResponse>.self)
                     print("success")
                    completion(.success(data))
                } catch {
                    print(response)
                    completion(.failure(error))
                }
            case .failure(let error):
                Toaster.shared.makeToast("프로필 로딩 중 에러가 발생했습니다.")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }
    
    static func changeProfile(name: String, image: Data?, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.MyPageProvider.request(.changeProfile(name: name, image: image)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("프로필 수정 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func changeBasicAnswers(_ userParameter: HealthInfoAnswerRequest, questionNum: Int, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.MyPageProvider.request(.changeAnswer(questionNum: questionNum, param: userParameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("건강 질문 답변 수정 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func changeVegetarian(keyword: String, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.MyPageProvider.request(.changeVegetarian(vegetarian: keyword)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("비건 선택 수정 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func changeDiet(keyword: String, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.MyPageProvider.request(.changeDiet(diet: keyword)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("다이어트 선택 수정 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func getMyReviews(completion: @escaping (Result<DefaultResponse<ReviewResponse> , Error>) -> Void) {
        APIManager.MyPageProvider.request(.getReview) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DefaultResponse<ReviewResponse>.self)
                     print("success")
                    completion(.success(data))
                } catch {
                    print(response)
                    completion(.failure(error))
                }
            case .failure(let error):
                Toaster.shared.makeToast("내가 쓴 리뷰를 불러오는 중 에러가 발생했습니다.")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }
    
    static func getMyHealthInfo(completion: @escaping (Result<DefaultResponse<MyHealthInfoResponse> , Error>) -> Void) {
        APIManager.MyPageProvider.request(.getHealthInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DefaultResponse<MyHealthInfoResponse>.self)
                    print("success")
                    completion(.success(data))
                } catch {
                    print(response)
                    completion(.failure(error))
                }
            case .failure(let error):
                Toaster.shared.makeToast("내 건강 정보를 불러오는 중 에러가 발생했습니다.")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }


    
    static func deleteReview(_ reviewId: Int, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.MyPageProvider.request(.deleteReview(reviewId: reviewId)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("내 리뷰 삭제 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
}



