// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then

class HealthGoalVC: UIViewController, HealthGoalCellDelegate, HealthGoalUpdateDelegate {
    
    
    private var isFetchingData = false
    private var currentPage = 2
    private var isLastPage = false
    var activeTextView: UITextView?
    private var keyboardHeight: CGFloat = 0
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
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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
    
        scrollView.delegate = self
        hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstUpdate = true
        currentPage = 1
        fetchHealthGoalData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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

    
    
    
    //MARK: - Setup Actions
    func didTapSettingButton(in cell: HealthGoalCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let bottomSheet = HGBottomSheetVC()
        let healthGoal = healthGoalList[indexPath.row]
        bottomSheet.planId = healthGoal.id
        bottomSheet.duration = healthGoal.duration.title
        bottomSheet.count = healthGoal.goalNumber
        bottomSheet.goal = healthGoal.goal
        bottomSheet.goalNum = indexPath.row + 1
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
        self.currentPage = 1
        self.isFirstUpdate = true
        fetchHealthGoalData()
    }
    
    private func updateCollectionViewHeight() {
        let tempHeight = CGFloat(max(335, healthGoalList.count * 335)) // 최소 높이 보장
        let collectionViewHeight = tempHeight + keyboardHeight
        
        if isFirstUpdate {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(collectionViewHeight)
                }
                self.view.layoutIfNeeded()
            })
            isFirstUpdate = false
        } else {
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionViewHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        keyboardHeight = keyboardFrameInView.height - view.safeAreaInsets.bottom

        updateCollectionViewHeight()
        
        if let activeTextView = activeTextView {
            let textViewFrame = activeTextView.convert(activeTextView.bounds, to: scrollView)

            let textViewY = textViewFrame.origin.y
            let targetY = textViewY - (scrollView.frame.height - keyboardHeight - 80)  // 80은 여유공간
            if targetY > 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: targetY), animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] is CGRect else { return }
        keyboardHeight = 0
        
        updateCollectionViewHeight()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
                self.currentPage = 1
                self.isFirstUpdate = true
                self.fetchHealthGoalData()
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("건강목표 저장 서버 에러 메시지: \(errorMessage)")
                }
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

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
