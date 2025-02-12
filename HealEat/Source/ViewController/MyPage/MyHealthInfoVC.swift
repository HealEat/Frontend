// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class MyHealthInfoVC: UIViewController {
    
    private let purposevc = PurposeVC()
    private let myhealthinfoview = MyHealthInfoView()
    private var healthInfo: MyHealthInfoResponse?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        setupNavigationBar()
        fetchHealthInfo()
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
        
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        
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
        
        view.addSubview(myhealthinfoview)
        myhealthinfoview.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func settingButtonTapped() {
        purposevc.modalPresentationStyle = .fullScreen
        present(purposevc, animated: true, completion: nil)
    }

    //MARK: - API call

    private func fetchHealthInfo() {
        MyPageManager.getMyHealthInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let healthInfo = response.result {
                    print("🔥 API 응답 데이터: \(healthInfo)")
                    
                    DispatchQueue.main.async {
                        self.healthInfo = healthInfo
                        self.myhealthinfoview.updateUI(with: healthInfo)
                    }
                    } else {
                        print("⚠️ API 응답 데이터가 nil입니다.")
                }
            case .failure(let error):
                print("내 건강 정보 조회 실패: \(error.localizedDescription)")
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
}
