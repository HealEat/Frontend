// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then

class HealthGoalVC: UIViewController {
    var userName: String?
    var healthGoalList: [HealthPlan] = [
        HealthPlan(id: 0, name: "김서현", duration: "일주일", goalNumber: 7, count: 3, goal: "9시 전 취침", memo: "힘들지만 화이팅!", memoImages: []),
        HealthPlan(id: 1, name: "김서현", duration: "한 달", goalNumber: 3, count: 1, goal: "매일 스트레칭하기", memo: "유튜브 참고", memoImages: [])]
    
    // MARK: - UI Properties
    private let makeGoalsView = MakeGoalsView()
    private let goalSeparatorView = GoalSeparatorView()
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 5
    })).then {
        $0.register(HealthGoalCell.self, forCellWithReuseIdentifier: HealthGoalCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
    }
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        //fetchHealthGoalData()
        saveHealthGoalData()
        navigationController?.navigationBar.isHidden = true
    }
    

    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        view.addSubview(scrollView)
        [makeGoalsView, goalSeparatorView, collectionView].forEach {
            scrollView.addSubview($0)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        makeGoalsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(285)
        }
        goalSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(65)
            make.top.equalTo(makeGoalsView.snp.bottom)
        }
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.top.equalTo(goalSeparatorView.snp.bottom)
            make.height.equalTo(healthGoalList.count * 258)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    //MARK: - Setup Actions
    
    
    
    //MARK: - API call
    private func fetchHealthGoalData() {
        HealthGoalManager.getHealthGoals { result in
            switch result {
            case .success(let healthGoal):
                print(healthGoal)
            case .failure(let error):
                print("실패")
            }
        }
    }
    
    private func saveHealthGoalData() {
        let healthGoal = HealthGoalRequest(duration: "WEEK", number: 4, goal: "일찍 일어나기")
        HealthGoalManager.postHealthGoal(healthGoal) { isSuccess, response in
            if isSuccess {
                print("성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("서버 에러 메시지: \(errorMessage)")
                }
            }
        }
    }


}


extension HealthGoalVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthGoalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HealthGoalCell.identifier, for: indexPath) as! HealthGoalCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right // 컬렉션 뷰의 너비에 맞춤
        return CGSize(width: width, height: 258) // 높이는 고정, 너비는 동적
    }
    
}
