// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then

class HealthGoalVC: UIViewController, HealthGoalCellDelegate, HealthGoalUpdateDelegate {
    
    var userName: String?
    var healthGoalList: [HealthPlan] = []
    var healthGoalRequest: HealthGoalRequest? {
        didSet {
            guard let goal = healthGoalRequest else { return }
            saveHealthGoalData(goal: goal)
        }
    }
    
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
        $0.register(NoHealthGoalCell.self, forCellWithReuseIdentifier: NoHealthGoalCell.identifier)
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
        
        navigationController?.navigationBar.isHidden = true
        fetchUserProfile()
        
        if let image1 = UIImage(named: "example1"),
           let image2 = UIImage(named: "example2" ) {
            uploadImages(planId: 1, images: [image1, image2])
        }
        
        
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
        makeGoalsView.vc = self
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
            make.height.equalTo(max(258, healthGoalList.count * 258))
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateCollectionViewHeight() {
        let collectionViewHeight = max(258, healthGoalList.count * 258) // 최소 높이 보장
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionViewHeight)
            }
            self.view.layoutIfNeeded() // 레이아웃 업데이트
        })
    }
    
    
    
    //MARK: - Setup Actions
    func didTapButton(in cell: HealthGoalCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let bottomSheet = HGBottomSheetVC()
        bottomSheet.goalNum = indexPath.row + 1
        bottomSheet.planId = healthGoalList[indexPath.row].id
        bottomSheet.delegate = self
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.3 // ✅ 화면 높이의 30% 크기로 설정
            })]
            sheet.prefersGrabberVisible = true
        }
        present(bottomSheet, animated: true)
    }
    
    func didUpdateHealthGoal() {
        fetchHealthGoalData()
    }
    

    
    
    //MARK: - API call
    private func fetchUserProfile() {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.makeGoalsView.userName = data.result?.name ?? "이용자"
                    self.goalSeparatorView.userName = data.result?.name ?? "이용자"
                }
            case .failure(let error):
                print("유저 프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchHealthGoalData() {
        HealthGoalManager.getHealthGoals { result in
            switch result {
            case .success(let data):
                self.healthGoalList = data.result?.healthPlanList ?? []
                DispatchQueue.main.async {
                    self.goalSeparatorView.goalCount = data.result?.healthPlanList.count
                    self.collectionView.reloadData()
                    self.updateCollectionViewHeight() // 높이 업데이트
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
                self.fetchHealthGoalData()
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("건강목표 저장 서버 에러 메시지: \(errorMessage)")
                }
            }
        }
    }
    
    private func uploadImages(planId: Int, images: [UIImage]) {
        HealthGoalManager.uploadImage(planId: planId, images: images) { isSuccess, response in
            if isSuccess {
                print("이미지 업로드 성공")
                self.fetchHealthGoalData()
            } else {
                print("🎨 이미지 업로드 서버 에러: \(response ?? "response 없음")")
            
            }
        }
    }


}


extension HealthGoalVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthGoalList.isEmpty ? 1 : healthGoalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if healthGoalList.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoHealthGoalCell.identifier, for: indexPath) as! NoHealthGoalCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HealthGoalCell.identifier, for: indexPath) as! HealthGoalCell
            cell.delegate = self
            let data = healthGoalList[indexPath.row]
            cell.goalCountLabel.text = "목표\(indexPath.row + 1)"
            let duration = TimeUnit(rawValue: data.duration) ?? .none
            cell.periodTextLabel?.text = duration.inKorean
            cell.countTextLabel?.text = "\(data.goalNumber)회"
            cell.goalTextLabel?.text = data.goal
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right // 컬렉션 뷰의 너비에 맞춤
        return CGSize(width: width, height: 258) // 높이는 고정, 너비는 동적
    }
    
}
