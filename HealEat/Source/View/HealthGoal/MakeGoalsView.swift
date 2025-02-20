// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster

class MakeGoalsView: UIView, DropDownDataSourceDelegate, UITextFieldDelegate {
    
    var userName: String? {
        didSet {
            updateUI()
        }
    }
    var duration : String?
    var count : String?
    
    weak var vc: HealthGoalVC?
    
    private let dateDataSource = DropDownDataSource(items: ["하루", "일주일", "열흘", "한달"])
    private let countDataSource = DropDownDataSource(items: ["1회", "2회", "3회", "4회", "5회", "6회", "7회", "8회", "9회", "10회"])
    
    // MARK: - UI Properties
    private lazy var goalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 20
    }

    private lazy var goalLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .healeatGray6
    }
    
    private lazy var goalBackground = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FBFBFB") ?? .gray
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.healeatGray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var backgroundStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 7
    }
    
    private lazy var dateButton = DropDownButton().then {
        $0.label.text = "기간"
    }
    
    private lazy var countButton = DropDownButton().then {
        $0.label.text = "횟수"
    }
    
    private lazy var goalTextField = UITextField().then {
        let fullText = "목표 (직접 입력)"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.foregroundColor: UIColor.healeatGray5, .font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        let range = (fullText as NSString).range(of: "(직접 작성)")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 10, weight: .medium), range: range)
        $0.attributedPlaceholder = attributedString
        
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.textColor = .healeatGray5
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textAlignment = .left
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
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
        addTargets()
        goalTextField.delegate = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        [goalLabel, goalBackground].forEach(goalStackView.addArrangedSubview(_:))
        [dateButton, countButton, goalTextField].forEach(backgroundStack.addArrangedSubview(_:))
        addSubview(goalStackView)
        goalBackground.addSubview(backgroundStack)
        addSubview(dateDropDownTableView)
        addSubview(countDropDownTableView)
        dateDropDownTableView.isHidden = true
        countDropDownTableView.isHidden = true
        dateDataSource.delegate = self
        countDataSource.delegate = self
        
        
        goalStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        goalBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges).inset(25)
            make.height.equalTo(53)
        }
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(32)
        }
        countButton.snp.makeConstraints { make in
            make.width.equalTo(67)
            make.height.equalTo(32)
        }
        goalTextField.snp.makeConstraints { make in
            make.width.equalTo(146)
            make.height.equalTo(32)
        }
        backgroundStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dateDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom)
            make.leading.equalTo(dateButton.snp.leading)
            make.width.equalTo(dateButton.snp.width)
            make.height.equalTo(80)  // 고정 높이
        }
        countDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(countButton.snp.bottom)
            make.leading.equalTo(countButton.snp.leading)
            make.width.equalTo(countButton.snp.width)
            make.height.equalTo(80)  // 고정 높이
        }
    }

    private func updateUI() {
        let fullText = "\(userName ?? "이용자") 님만의 건강 관리 목표를 세워보세요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let nameRange = (fullText as NSString).range(of: "\(userName ?? "이용자")")
        attributedString.addAttribute(.foregroundColor, value: UIColor.healeatGreen1.cgColor, range: nameRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nameRange)
        
        goalLabel.attributedText = attributedString
    }
    
    // MARK: - Action Methods
    private func addTargets() {
        dateButton.addTarget(self, action: #selector(dateBtnClicked), for: .touchUpInside)
        countButton.addTarget(self, action: #selector(countBtnClicked), for: .touchUpInside)
    }
    
    @objc private func dateBtnClicked() {
        let isHidden = dateDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.dateDropDownTableView.isHidden = !isHidden
            self.layoutIfNeeded()
        }
    }
    
    @objc private func countBtnClicked() {
        let isHidden = countDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.countDropDownTableView.isHidden = !isHidden
            self.layoutIfNeeded()
        }
    }

    // ✅ delegate 메서드 구현 → healthGoal에 값 저장
    func dropDownDidSelect(item: String, from tag: Int) {
        switch tag {
        case 0:
            self.duration = item  // ✅ 날짜 선택
            dateButton.label.text = item
        case 1:
            self.count = item  // ✅ 횟수 선택
            countButton.label.text = item
        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 여기서 Post method 구현
        guard let duration = duration else {
            Toaster.shared.makeToast("기간을 입력해주세요.")
            return false
        }
        guard let durationEnum = HealthPlanDuration.fromKorean(duration)?.rawValue else {
            Toaster.shared.makeToast("기간을 입력해주세요.")
            return false
        }
        
        guard let count = count else {
            Toaster.shared.makeToast("횟수를 입력해주세요.")
            return false
        }
        
        guard let countInNum = count.extractNumber else {
            Toaster.shared.makeToast("횟수를 입력해주세요.")
            return false
        }
        
        guard let goal = textField.text, !goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            Toaster.shared.makeToast("작성된 목표가 없습니다.")
            return false
        }
        vc?.healthGoalRequest = HealthGoalRequest(duration: durationEnum, number: countInNum, goal: goal, removeImageIds: [])
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let markedTextRange = textField.markedTextRange {
            return true // 한글 조합 중이면 그대로 허용
        }

        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)

        //  유니코드로 문자열 길이 확인 (한글 받침 포함 정확한 개수 계산)
        return updatedText.precomposedStringWithCanonicalMapping.count <= 11
    }

    
    

 
    

}
