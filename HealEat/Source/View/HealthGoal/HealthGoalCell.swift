// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SDWebImage

class HealthGoalCell: UICollectionViewCell {
     
    static let identifier = "HealthGoalCell"
    weak var delegate: HealthGoalCellDelegate?
    
    // MARK: - UI Properties
    private lazy var goalBackgroundStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    private lazy var goalBackground = UIView().then {
        $0.backgroundColor = UIColor(hex: "#FBFBFB")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CDCDCD")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    
    public lazy var goalCountLabel = UILabel().then {
        $0.text = "목표1"
        $0.textColor = UIColor(hex: "7D7D7D")
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    // `UILabel`을 외부에서 사용할 수 있도록
    public var periodTextLabel: UILabel?
    public var countTextLabel: UILabel?
    public var goalTextLabel: UILabel?
    
    public lazy var periodLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "일주일"
            label.textColor = .healeatGray5
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        self.periodTextLabel = label // 외부에서 접근할 수 있도록 저장
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CFCFCF")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    public lazy var countLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "3회"
            label.textColor = .healeatGray5
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        self.countTextLabel = label
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CFCFCF")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    public lazy var goalLabel = UIView().then {
        let label = UILabel().then { label in
            label.text = "저염식하기"
            label.textColor = .healeatGray5
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        self.goalTextLabel = label
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#CFCFCF")?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
        $0.tintColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private lazy var memoView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
    }
    private lazy var memoDescription = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .healeatGray6
        let fullText = "MEMO (글자 최대 200자, 사진 최대 5장)"
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "(글자 최대 200자, 사진 최대 5장)")
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 11, weight: .light), range: range)
        attributedText.addAttribute(.foregroundColor, value: UIColor.healeatGray5, range: range)
        $0.attributedText = attributedText
        $0.numberOfLines = 1
    }
    
    private lazy var memoImage = UIImageView().then {
        $0.image = UIImage(named: "Placeholder")
    }
    
    private lazy var memoTextView = MemoTextView().then {
        $0.placeholder = "메모를 입력하세요."
        $0.placeholderColor = UIColor.healeatGray6
        $0.textColor = UIColor.healeatGray6
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.isScrollEnabled = false // 🔥 내용이 많아지면 자동 확장!
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.textContainer.lineFragmentPadding = 0 // ✅ 좌우 패딩 제거
        $0.delegate = self
    }
    
    private lazy var uploadImageButton = UIButton().then {
        $0.setImage(UIImage(named: "addImageButton"), for: .normal)
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    private lazy var failButton = GoalStatusButton(title: "달성 실패", selectedBackground: .healeatGray3, selectedTitleColor: .healeatGray5)
    private lazy var progressButton = GoalStatusButton(title: "진행 중", selectedBackground: .healeatLightGreen, selectedTitleColor: .healeatGreen1)
    private lazy var completeButton = GoalStatusButton(title: "달성 완료", selectedBackground: .healeatLightGreen, selectedTitleColor: .healeatGreen1)

    private lazy var statusStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }

    
    
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        [goalCountLabel, periodLabel, countLabel,goalLabel].forEach(goalBackgroundStack.addArrangedSubview(_:))
        
        [failButton, progressButton, completeButton].forEach(statusStack.addArrangedSubview(_:))
        [memoDescription, memoTextView].forEach { memoView.addSubview($0) }
        [goalBackgroundStack, settingButton].forEach { goalBackground.addSubview($0) }
        [goalBackground, memoView, uploadImageButton, imageStackView, statusStack].forEach { addSubview($0) }
        
        settingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        goalBackground.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
        }
        goalBackgroundStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(settingButton.snp.leading).offset(-20)
        }
        settingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        periodLabel.snp.makeConstraints { make in
            make.width.equalTo(66)
            make.height.equalTo(32)
        }
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(32)
        }
        goalLabel.snp.makeConstraints { make in
            make.width.equalTo(89)
            make.height.equalTo(32)
        }
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        
        memoView.snp.makeConstraints { make in
            make.top.equalTo(goalBackground.snp.bottom).offset(15)
            make.height.equalTo(95)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        memoDescription.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(18)
        }
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoDescription.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        uploadImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(68)
            make.top.equalTo(memoView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(memoView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(15)
        }
        statusStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
    }

    // 내부 토글 액션
    @objc func handleToggle(_ sender: UIButton) {
        sender.isSelected.toggle() // 버튼 상태 전환
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapButton(in: self)  // ✅ Delegate 호출하여 ViewController로 이벤트 전달
    }
    
    func configure(with data: HealthPlan) {
        if data.healthPlanImages.isEmpty {
            // 이미지가 없으면 버튼만 표시
            imageStackView.isHidden = true
            uploadImageButton.isHidden = false
        } else {
            // 이미지가 있으면 버튼을 숨기고 이미지뷰 추가
            imageStackView.isHidden = false
            uploadImageButton.isHidden = true
            updateImageStack(with: data.healthPlanImages)
        }
        
        
        [failButton, progressButton, completeButton].forEach { $0.updateState(isSelected: false) }

        // 데이터에서 받은 duration 값에 따라 버튼 선택
        switch data.status {
        case .fail:
            failButton.updateState(isSelected: true)
        case .progress:
            progressButton.updateState(isSelected: true)
        case .complete:
            completeButton.updateState(isSelected: true)
        }
    }
    
    
    
    private func updateImageStack(with images: [MemoImage]) {
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for image in images {
            let url = image.imageUrl
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 9
            imageView.layer.masksToBounds = true
            imageView.sd_setImage(with: URL(string: url))
            imageView.snp.makeConstraints { $0.height.width.equalTo(70) }
            imageStackView.addArrangedSubview(imageView)
        }
    }
}


protocol HealthGoalCellDelegate: AnyObject {
    func didTapButton(in cell: HealthGoalCell)
}


extension HealthGoalCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let placeholderTextView = textView as? MemoTextView else { return }
        placeholderTextView.setNeedsDisplay()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        // 🔥 현재 입력된 텍스트 + 새로 입력될 텍스트 포함한 전체 길이 계산
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // 🔥 글자 수 제한 (최대 200자)
        if newText.utf16.count > 200 {
            return false
        }

        // 🔥 textView의 최대 크기 (현재 높이 기준)
        let maxSize = textView.frame.size
        let fittingSize = textView.sizeThatFits(CGSize(width: maxSize.width, height: CGFloat.greatestFiniteMagnitude))

        // ✅ 높이를 초과하면 입력 차단
        if fittingSize.height > maxSize.height {
            return false
        }
        
        return true
    }
}
