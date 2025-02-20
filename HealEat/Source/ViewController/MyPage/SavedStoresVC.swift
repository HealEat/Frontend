// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class SavedStoresVC: UIViewController {
    
    // MARK: - UI Properties
    private lazy var savedStoreTableView = UITableView().then {
        $0.register(StoreTableViewCell.self, forCellReuseIdentifier: String(describing: StoreTableViewCell.self))
        $0.separatorStyle = .none
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    
    // MARK: - UI Methods
    private func setUp() {
        view.backgroundColor = .white
        /*[imageView, textfield].forEach(profileStack.addArrangedSubview(_:))
        [profileStack, editButton].forEach {
            view.addSubview($0)
        }*/
        [savedStoreTableView, ].forEach {
            view.addSubview($0)
        }
        
//        savedStoreTableView.delegate = self
//        savedStoreTableView.dataSource = self
        
        savedStoreTableView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })

    }
    
    //MARK: - Setup Actions


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

//extension SavedStoresVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return storeResponseModels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoreTableViewCell.self), for: indexPath) as? StoreTableViewCell else { return UITableViewCell() }
//        
//        cell.configure(storeResponseModel: storeResponseModels[indexPath.row])
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = MarketVC()
//        vc.param = MarketVC.Param(placeId: storeResponseModels[indexPath.row].placeId)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
