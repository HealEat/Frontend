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
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 1
        $0.minimumInteritemSpacing = 1
    })).then {
        $0.register(HealthGoalCell.self, forCellWithReuseIdentifier: HealthGoalCell.identifier)
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
        
        let healthGoal = HealthGoalRequest(duration: "DAY", number: 3, goal: "물 마시기")
        let changeData = HealthGoalRequest(duration: "DAY", number: 4, goal: "일찍 자기")
        //saveHealthGoalData(goal: healthGoal)
        //deleteHealthGoalData(planId: 1)
        //changeHealthGoalData(planId: 2, goal: changeData)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHealthGoalData()
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
            case .success(let data):
                self.healthGoalList = data.result?.healthPlanList ?? []
                DispatchQueue.main.async {
                    self.makeGoalsView.userName = data.result?.healthPlanList[0].name
                    self.goalSeparatorView.userName = data.result?.healthPlanList[0].name
                    self.goalSeparatorView.goalCount = data.result?.healthPlanList.count
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("건강목표 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveHealthGoalData(goal: HealthGoalRequest) {
        
        HealthGoalManager.postHealthGoal(goal) { isSuccess, response in
            if isSuccess {
                print("건강목표 저장 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("서버 에러 메시지: \(errorMessage)")
                }
            }
        }
    }
    
    private func deleteHealthGoalData(planId: Int) {
        HealthGoalManager.deleteHealthGoal(planId) { isSuccess, response in
            if isSuccess {
                print("건강목표 삭제 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("서버 에러 메시지: \(errorMessage)")
                }
            }
        }
    }
    
    private func changeHealthGoalData(planId: Int, goal: HealthGoalRequest) {
        HealthGoalManager.changeHealthGoal(goal, planId: planId) { isSuccess, response in
            if isSuccess {
                print("건강목표 수정 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
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
        let data = healthGoalList[indexPath.row]
        cell.goalCountLabel.text = "목표\(indexPath.row + 1)"
        let duration = TimeUnit(rawValue: data.duration) ?? .none
        cell.periodTextLabel?.text = duration.inKorean
        cell.countTextLabel?.text = "\(data.goalNumber)회"
        cell.goalTextLabel?.text = data.goal
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right // 컬렉션 뷰의 너비에 맞춤
        return CGSize(width: width, height: 258) // 높이는 고정, 너비는 동적
    }
    
}
