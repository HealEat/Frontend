// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MakeGoalsView: UIView, DropDownDataSourceDelegate, UITextFieldDelegate {
    
    var userName: String? {
        didSet {
            updateUI()
        }
    }
    var duration : String?
    var number : String?
    //var healthGoal = HealthGoalRequest(duration: "", number: 0, goal: "")
    
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
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = UIColor(hex: "#4E4E4E")
    }
    
    private lazy var goalBackground = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FBFBFB")
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CDCDCD")?.cgColor
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
        let fullText = "         목표 (직접 작성)"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.foregroundColor: UIColor(hex: "#797979") ?? UIColor.gray, .font: UIFont.systemFont(ofSize: 10, weight: .medium)])
        let range = (fullText as NSString).range(of: "(직접 작성)")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 7, weight: .medium), range: range)
        $0.attributedPlaceholder = attributedString
        
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.textColor = UIColor(hex: "#797979")
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
            make.width.equalTo(306)
            make.height.equalTo(53)
        }
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(28)
        }
        countButton.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(28)
        }
        goalTextField.snp.makeConstraints { make in
            make.width.equalTo(146)
            make.height.equalTo(28)
        }
        backgroundStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dateDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom)
            make.leading.equalTo(dateButton.snp.leading)
            make.width.equalTo(dateButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
        countDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(countButton.snp.bottom)
            make.leading.equalTo(countButton.snp.leading)
            make.width.equalTo(countButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
    }

    private func updateUI() {
        let fullText = "\(userName ?? "이용자") 님만의 건강 관리 목표를 세워보세요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let nameRange = (fullText as NSString).range(of: "\(userName ?? "이용자")")
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#009459") ?? UIColor.green, range: nameRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .medium), range: nameRange)
        
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
            self.number = item  // ✅ 횟수 선택
            countButton.label.text = item
        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 여기서 Post method 구현하기
        print("입력 완료 \(textField.text ?? "")")
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }
 
    

}

extension UITextField {
    func addLeftPadding() {
        // width값에 원하는 padding 값을 넣어줍니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
