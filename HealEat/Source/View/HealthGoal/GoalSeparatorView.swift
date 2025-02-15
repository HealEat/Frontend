// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class GoalSeparatorView: UIView {
    var userName: String? 
    var goalCount: Int? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Properties
    private lazy var separator1 = UIView().then {
        $0.backgroundColor = .healeatGray3
    }
    private lazy var separator2 = UIView().then {
        $0.backgroundColor = .healeatGray3
    }
    
    private lazy var label = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.black
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
        [separator1, label, separator2].forEach {
            addSubview($0)
        }
        separator1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        separator2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.7)
        }
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateUI() {
        let fullText = "건강 관리 목표 (\(goalCount ?? 0))"
        let attributedString = NSMutableAttributedString(string: fullText)
        let countRange = (fullText as NSString).range(of: "(\(goalCount ?? 0))")
        attributedString.addAttribute(.foregroundColor, value: UIColor.healeatGray6, range: countRange)
        
        label.attributedText = attributedString
    }
}
