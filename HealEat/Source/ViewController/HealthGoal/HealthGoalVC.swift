// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then

class HealthGoalVC: UIViewController, HealthGoalCellDelegate, HealthGoalUpdateDelegate {
    
    private var isFetchingData = false
    private var currentPage = 2
    private var isLastPage = false
    private var isFirstUpdate = true
    
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
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstUpdate = true
        currentPage = 1
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
            make.height.equalTo(265)
        }
        goalSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(43)
            make.top.equalTo(makeGoalsView.snp.bottom)
        }
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.top.equalTo(goalSeparatorView.snp.bottom)
            make.height.equalTo(max(335, healthGoalList.count * 335))
            make.bottom.equalToSuperview()
        }
    }

    private func updateCollectionViewHeight() {
        let collectionViewHeight = max(335, healthGoalList.count * 335) // 최소 높이 보장
        
        if isFirstUpdate {
            // ✅ 첫 번째 업데이트만 애니메이션 적용
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(collectionViewHeight)
                }
                self.view.layoutIfNeeded()
            })
            isFirstUpdate = false
        } else {
            // ✅ 이후에는 애니메이션 없이 즉시 업데이트
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionViewHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    
    
    
    //MARK: - Setup Actions
    func didTapSettingButton(in cell: HealthGoalCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let bottomSheet = HGBottomSheetVC()
        bottomSheet.goalNum = indexPath.row + 1
        bottomSheet.planId = healthGoalList[indexPath.row].id
        bottomSheet.existingImages = healthGoalList[indexPath.row].healthPlanImages
        bottomSheet.delegate = self
        bottomSheet.overrideUserInterfaceStyle = .dark
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.7
            })]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
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
                }
            case .failure(let error):
                print("유저 프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchHealthGoalData() {
        HealthGoalManager.getHealthGoals(page: currentPage) { result in
            switch result {
            case .success(let data):
                guard let result = data.result else { return }
                self.healthGoalList = result.healthPlanList
                self.isLastPage = result.isLast
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.goalSeparatorView.goalCount = result.healthPlanList.count
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
    
    func didTapStatusButton(in cell: HealthGoalCell, status: HealthPlanStatus) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let planId = healthGoalList[indexPath.row].id
        let statusInString = status.rawValue
        HealthGoalManager.uploadHealthGoalStatus(planId: planId, status: statusInString) { isSuccess, response in
            if isSuccess {
                print("진행 상태 수정 성공: \(response)")
                self.currentPage = 1
                self.isFirstUpdate = false
                self.fetchHealthGoalData()
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("진행 상태 수정 실패: \(errorMessage)")
                }
            }
        }
    }
    
    func didSubmitMemo(in cell: HealthGoalCell, memo: String) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let planId = healthGoalList[indexPath.row].id
        print("memo란 이것이다: \(memo)")
        HealthGoalManager.uploadHealthGoalMemo(planId: planId, memo: memo) { isSuccess, response in
            if isSuccess {
                print("메모 업로드 성공: \(response)")
                self.currentPage = 1
                self.isFirstUpdate = false
                self.fetchHealthGoalData()
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("진행 상태 수정 실패: \(errorMessage)")
                }
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
            cell.configure(with: healthGoalList[indexPath.row])
            let data = healthGoalList[indexPath.row]
            cell.goalCountLabel.text = "목표\(indexPath.row + 1)"
            cell.periodTextLabel?.text = data.duration.title
            cell.countTextLabel?.text = "\(data.goalNumber)회"
            cell.goalTextLabel?.text = data.goal
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right // 컬렉션 뷰의 너비에 맞춤
        return CGSize(width: width, height: 335) // 높이는 고정, 너비는 동적
    }
    
}

extension HealthGoalVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height

        // 🔥 scrollView가 끝까지 도달했을 때 API 호출
        if offsetY > contentHeight - frameHeight - 10 {
            guard !isFetchingData, !isLastPage else { return }
            isFetchingData = true
            fetchHealthGoalData()
        }
    }
}
