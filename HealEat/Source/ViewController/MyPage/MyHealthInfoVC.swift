// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MyHealthInfoVC: UIViewController {
    
    private let mypagevc = MyPageVC()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIButton(type: .system)

           
        let backImage = UIImage(named: "backimage")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        backButton.setTitle(" 마이페이지", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

            
        backButton.sizeToFit()

        let backBarButton = UIBarButtonItem(customView: backButton)
        
        // 환경설정 아이콘 (UIButton)
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(named: "settingimage"), for: .normal)
        settingButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        
        // 기존 백 버튼이 자동으로 설정되도록 leftBarButtonItem은 그대로 두고, 추가적으로 환경설정 아이콘만 넣기
        navigationItem.leftBarButtonItems = [backBarButton, settingBarButton]
    }
   
    // MARK: - UI Methods
    private func setUp() {
        view.backgroundColor = .white
        /*[imageView, textfield].forEach(profileStack.addArrangedSubview(_:))
        [profileStack, editButton].forEach {
            view.addSubview($0)
        }*/
        

    }
    
    //MARK: - Setup Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    //MARK: - API call
    private func fetchProfile() {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let profile):
                print(profile)
                guard let data = profile.result else { return }
                let profileImgURL = URL(string: data.profileImage)
                //self.imageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profile"))
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


