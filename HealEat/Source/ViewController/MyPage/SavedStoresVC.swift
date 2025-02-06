// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class SavedStoresVC: UIViewController {

    private let storeResponseModels: [StoreResponseModel] = [
        StoreResponseModel(
            placeId: 99,
            placeName: "본죽&비빔밥cafe 홍대점 (테스트)",
            categoryName: "죽",
            phone: "010-1234-5678",
            addressName: "서울 마포구 홍익로 10 106호",
            roadAddressName: "서울 마포구 홍익로 10 106호",
            x: "37.553851",
            y: "126.923388",
            placeUrl: URL(string: "https://place.map.kakao.com/287510690")!,
            features: ["속 편한 음식", "야채", "죽", "따뜻한 음식"],
            imageUrls: [
                URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
            ],
            isInDB: true,
            totalScore: 4.4,
            reviewCount: 23,
            sickScore: 4.7,
            sickCount: 15,
            vegetScore: 3.4,
            vegetCount: 13,
            dietScore: 4.3,
            dietCount: 5,
            isBookMarked: true
        ),
    ]
    
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
        
        savedStoreTableView.delegate = self
        savedStoreTableView.dataSource = self
        
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

extension SavedStoresVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeResponseModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoreTableViewCell.self), for: indexPath) as? StoreTableViewCell else { return UITableViewCell() }
        
        cell.configure(storeResponseModel: storeResponseModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MarketVC()
        vc.param = MarketVC.Param(storeResponseModel: storeResponseModels[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
