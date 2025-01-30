// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MyPageVC: UIViewController {

    let menu = ["나의 건강 정보", "저장 목록", "내가 남긴 후기"]
    
    // MARK: - UI Properties
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
    }
    private lazy var profileLabel = UILabel().then {
        $0.text = "이용자"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    private lazy var profileEditButton = UIButton().then {
        $0.setTitle("프로필 수정하기", for: .normal)
        $0.setTitleColor(UIColor(hex: "#5A5A5A"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(hex: "#5A5A5A")?.cgColor //gray6으로 변경
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
    }
    private lazy var profileStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 20
        $0.distribution = .fill
    }
    private lazy var profileDetailStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 15
        $0.distribution = .fill
    }
    private lazy var tableview = UITableView().then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

        //fetchProfile()
        //fetchReview()
        //fetchHealthInfo()
    }
    
    // MARK: - UI Methods
    private func setUp() {
        [profileLabel, profileEditButton].forEach(profileDetailStack.addArrangedSubview(_:))
        [profileImageView, profileDetailStack].forEach(profileStack.addArrangedSubview(_:))
        [profileStack, tableview].forEach {
            view.addSubview($0)
        }
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // ✅ 기본 셀 등록
        
        profileStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.4)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(85)
        }
        profileEditButton.snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(24)
        }
        tableview.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    

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


extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    
}
