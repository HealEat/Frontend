// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class HGBottomSheetVC: UIViewController, DropDownDataSourceDelegate {
    weak var delegate: HealthGoalUpdateDelegate?

    var planId: Int?
    var goalNum: Int?
    var duration: String?
    var count: String?
    var goal: String?
    
    private let dateDataSource = DropDownDataSource(items: ["하루", "일주일", "열흘", "한달"])
    private let countDataSource = DropDownDataSource(items: ["1회", "2회", "3회", "4회", "5회", "6회", "7회", "8회", "9회", "10회"])
    
    // MARK: - UI Properties
    private lazy var goalNumLabel = UILabel().then {
        $0.text = "목표 \(goalNum ?? 0)"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    private lazy var durationLabel = UILabel().then {
        $0.text = "기간"
        $0.textColor = UIColor(hex: "#747474")
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    private lazy var countLabel = UILabel().then {
        $0.text = "횟수"
        $0.textColor = UIColor(hex: "#747474")
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    private lazy var goalLabel = UILabel().then {
        $0.text = "목표"
        $0.textColor = UIColor(hex: "#747474")
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    private lazy var durationButton = DropDownButton().then {
        $0.label.text = "기간을 선택하세요."
    }
    private lazy var countButton = DropDownButton().then {
        $0.label.text = "횟수를 선택하세요."
    }
    private lazy var goalTextField = UITextField().then {
        $0.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        let fullText = "목표를 작성하세요."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.foregroundColor: UIColor(hex: "#797979") ?? UIColor.gray, .font: UIFont.systemFont(ofSize: 10, weight: .medium)])
        $0.attributedPlaceholder = attributedString
        $0.addLeftPadding()
        $0.textColor = UIColor(hex: "#797979")
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textAlignment = .left
    }
    private lazy var deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.backgroundColor = UIColor(hex: "#A1A1A1")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private lazy var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        
    }
    
    private lazy var durationStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 15
    }
    private lazy var countStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 15
    }
    private lazy var goalStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 15
    }
    private lazy var buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 25
    }
    
    private lazy var dateDropDownTableView = DropDownTableView().then {
        $0.delegate = dateDataSource
        $0.dataSource = dateDataSource
        $0.tag = 0
    }
    
    private lazy var countDropDownTableView = DropDownTableView().then {
        $0.delegate = countDataSource
        $0.dataSource = countDataSource
        $0.tag = 1
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: - UI Methods
    private func setupView() {
        view.backgroundColor = .white
        [durationLabel, durationButton].forEach(durationStack.addArrangedSubview(_:))
        [countLabel, countButton].forEach(countStack.addArrangedSubview(_:))
        [goalLabel, goalTextField].forEach(goalStack.addArrangedSubview(_:))
        [deleteButton, saveButton].forEach(buttonStack.addArrangedSubview(_:))
        [goalNumLabel, durationStack, countStack, goalStack, buttonStack].forEach {
            view.addSubview($0)
        }
        [dateDropDownTableView, countDropDownTableView].forEach {
            view.addSubview($0)
        }
        dateDropDownTableView.isHidden = true
        countDropDownTableView.isHidden = true
        dateDataSource.delegate = self
        countDataSource.delegate = self
        
        goalNumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        durationStack.snp.makeConstraints { make in
            make.top.equalTo(goalNumLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
        }
        durationButton.snp.makeConstraints { make in
            make.width.equalTo(171)
            make.height.equalTo(23)
        }
        countStack.snp.makeConstraints { make in
            make.top.equalTo(durationStack.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        countButton.snp.makeConstraints { make in
            make.width.equalTo(171)
            make.height.equalTo(23)
        }
        goalStack.snp.makeConstraints { make in
            make.top.equalTo(countStack.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        goalTextField.snp.makeConstraints { make in
            make.width.equalTo(171)
            make.height.equalTo(23)
        }
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(goalStack.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(100)
            make.height.equalTo(35)
        }
        dateDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(durationButton.snp.bottom)
            make.leading.equalTo(durationButton.snp.leading)
            make.width.equalTo(durationButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
        countDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(countButton.snp.bottom)
            make.leading.equalTo(countButton.snp.leading)
            make.width.equalTo(countButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
        
        durationButton.addTarget(self, action: #selector(dateBtnClicked), for: .touchUpInside)
        countButton.addTarget(self, action: #selector(countBtnClicked), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteBtnClicked), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
    }
    
    
    //MARK: - Setup Actions
    @objc private func dateBtnClicked() {
        let isHidden = dateDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.dateDropDownTableView.isHidden = !isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func countBtnClicked() {
        let isHidden = countDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.countDropDownTableView.isHidden = !isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func deleteBtnClicked() {
        guard let planId = planId else { return }
        deleteHealthGoalData(planId: planId)
        dismiss(animated: true) {  // ✅ 바텀시트가 완전히 닫힌 후 실행
            self.delegate?.didUpdateHealthGoal()
        }
    }
    
    @objc private func saveBtnClicked() {
        guard let planId = planId else { return }
        guard let goal = goalTextField.text, !goal.isEmpty else {
            Toaster.shared.makeToast("❌ 목표를 작성해주세요.")
            return
        }
        guard let duration = duration else {
            Toaster.shared.makeToast("기간을 입력해주세요.")
            return
        }
        guard let durationEnum = TimeUnit.rawValue(fromKorean: duration) else {
            Toaster.shared.makeToast("기간을 입력해주세요.")
            return
        }
        
        guard let count = count else {
            Toaster.shared.makeToast("횟수를 입력해주세요.")
            return
        }
        
        guard let countInNum = count.extractNumber else {
            Toaster.shared.makeToast("횟수를 입력해주세요.")
            return
        }

        let healthgoal = HealthGoalRequest(duration: durationEnum, number: countInNum, goal: goal)
        
        changeHealthGoalData(planId: planId, goal: healthgoal)
        dismiss(animated: true) {  // ✅ 바텀시트가 완전히 닫힌 후 실행
            self.delegate?.didUpdateHealthGoal()
        }
    }
    
    
    func dropDownDidSelect(item: String, from tag: Int) {
        switch tag {
        case 0:
            self.duration = item  // ✅ 날짜 선택
            durationButton.label.text = item
        case 1:
            self.count = item  // ✅ 횟수 선택
            countButton.label.text = item
        default:
            break
        }
    }
    

    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
    
    
    //MARK: - API call
    private func deleteHealthGoalData(planId: Int) {
        HealthGoalManager.deleteHealthGoal(planId) { isSuccess, response in
            if isSuccess {
                print("건강목표 삭제 성공: \(response)")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("건강목표 삭제 서버 에러 메시지: \(errorMessage)")
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

protocol HealthGoalUpdateDelegate: AnyObject {
    func didUpdateHealthGoal()
}
