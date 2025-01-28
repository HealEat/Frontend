// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MyPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //fetchProfile()
        fetchReview()
        //fetchHealthInfo()
    }
    

    //MARK: - API call
    private func fetchProfile() {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let profile):
                print(profile)
            case .failure(let error):
                print("프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    private func fetchReview() {
        MyPageManager.getMyReviews { result in
            switch result {
            case .success(let reviews):
                print(reviews)
            case .failure(let error):
                print("내 리뷰 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    private func fetchHealthInfo() {
        MyPageManager.getMyHealthInfo { result in
            switch result {
            case .success(let healthInfo):
                print(healthInfo)
            case .failure(let error):
                print("내 건강 정보 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func changeProfile(profile: MyProfileRequest) {
        MyPageManager.changeProfile(profile) { isSuccess, response in
            if isSuccess {
                print("프로필 수정 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }
    
    private func changeHealthAnswer(questionNum: Int, answers: [String]) {
        MyPageManager.changeBasicAnswers(HealthInfoAnswerRequest(selectedAnswers: answers), questionNum: questionNum) { isSuccess, response in
            if isSuccess {
                print("답변 수정 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }
    
    private func changeVegetarian(vegetarianInfo: String) {
        MyPageManager.changeVegetarian(keyword: vegetarianInfo) { isSuccess, response in
            if isSuccess {
                print("채식 정보 수정 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }
    
    private func changeDiet(dietInfo: String) {
        MyPageManager.changeDiet(keyword: dietInfo) { isSuccess, response in
            if isSuccess {
                print("다이어트 정보 수정 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }
    
    private func deleteReview(reviewId: Int) {
        MyPageManager.deleteReview(reviewId){ isSuccess, response in
            if isSuccess {
                print("리뷰 삭제 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }

}
