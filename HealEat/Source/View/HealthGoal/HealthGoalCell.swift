// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SDWebImage

class HealthGoalCell: UICollectionViewCell {
     
    static let identifier = "HealthGoalCell"
    
    
    // MARK: - UI Properties
    private lazy var goalBackgroundStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var goalBackground = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FBFBFB")
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CDCDCD")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    
    private lazy var goalCountLabel = UILabel().then {
        $0.text = "목표1"
        $0.textColor = UIColor(hex: "7D7D7D")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    
    private lazy var periodLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "일주일"
            label.textColor = UIColor(hex: "#797979") ?? UIColor.gray
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var countLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "3회"
            label.textColor = UIColor(hex: "#797979") ?? UIColor.gray
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var goalLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "저염식하기"
            label.textColor = UIColor(hex: "#797979") ?? UIColor.gray
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var buttonImage = UIImageView().then {
        $0.image = UIImage(systemName: "gearshape")
        $0.tintColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private lazy var goalCountStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var memoView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
    }
    private lazy var memoDescription = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 7, weight: .medium)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
        let fullText = "Memo (글자 최대 200자, 사진 최대 5장)"
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "(글자 최대 200자, 사진 최대 5장)")
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 5, weight: .medium), range: range)
        $0.attributedText = attributedText
    }
    
    private lazy var memoImage = UIImageView().then {
        $0.image = UIImage(named: "Placeholder")
    }
    private lazy var memoLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 7, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "옆에는 사진, 여기에 이렇게 메모한 내용이 들어갑니다. \n사진과 텍스트는 따로 이루어지고 자세한 디자인은 디자이너님과 소통해보겠습니다."
    }
    
    private lazy var memoStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    private lazy var toDoRow = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 5
    }
    private lazy var toDoStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        setUpConstraints()
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// ViewController에서 만든 버튼을 셀에 추가
    func configure(with button: UIButton) {
    }
    
    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        [goalCountLabel, periodLabel, countLabel,goalLabel, buttonImage ].forEach(goalBackgroundStack.addArrangedSubview(_:))
        [memoImage, memoLabel].forEach(memoStack.addArrangedSubview(_:))
        
        goalBackground.addSubview(goalBackgroundStack)
        memoView.addSubview(memoDescription)
        memoView.addSubview(memoStack)
        
        [goalBackground, memoView].forEach {
            addSubview($0)
        }
        addSubview(goalBackground)
        
        goalBackground.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(15)
        }
        goalBackgroundStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        periodLabel.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(28)
        }
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(28)
        }
        goalLabel.snp.makeConstraints { make in
            make.width.equalTo(146)
            make.height.equalTo(28)
        }
        buttonImage.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        
        memoView.snp.makeConstraints { make in
            make.top.equalTo(goalBackground.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        memoDescription.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        memoStack.snp.makeConstraints { make in
            make.top.equalTo(memoDescription.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        /*memoImage.snp.makeConstraints { make in
            make.width.equalTo(82)
            make.height.equalTo(74)
        }*/
    }
    
    func addToDoList(count: Int) -> UIStackView {
        // Check Button (네모 모양 토글 버튼)
        let checkButton = UIButton()
        let notSelectedImage = UIImage(systemName: "square")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(systemName: "square.fill")?.withRenderingMode(.alwaysTemplate)
        
        checkButton.setImage(notSelectedImage, for: .normal)
        checkButton.setImage(selectedImage, for: .selected)
        checkButton.addTarget(nil, action: #selector(handleToggle(_:)), for: .touchUpInside)
        
        // Label
        let label = UILabel()
        label.text = "\(count)회"
        label.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        label.textAlignment = .center
        
        // Stack View to Layout Button and Label
        let stackView = UIStackView(arrangedSubviews: [checkButton, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        return stackView
    }

    // 내부 토글 액션
    @objc func handleToggle(_ sender: UIButton) {
        sender.isSelected.toggle() // 버튼 상태 전환
    }
    
    
    private func makeTodoList() {
        let numOfToDos = 6
        
    }
}

