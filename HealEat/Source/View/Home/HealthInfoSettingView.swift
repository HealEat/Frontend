// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class HealthInfoSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var userRecommendLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.text = "힐릿님 건강 맞춤 추천"
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "힐릿")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(red: 0.00, green: 0.58, blue: 0.35, alpha: 1.00), range: range)
        $0.attributedText = attribtuedString
    }
    
    public lazy var storeRecommendLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00)
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.text = "건강 정보를 설정하여\n건강 맞춤 매장을 추천\n받아보세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 4
    }
    
    public lazy var healthsettingButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        $0.backgroundColor = UIColor(red: 1.00, green: 0.96, blue: 0.96, alpha: 1.00)
        $0.setTitle("건강 정보 설정하기", for: .normal)
        $0.setTitleColor(UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00) , for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    private func setViews() {
        addSubview(userRecommendLabel)
        addSubview(storeRecommendLabel)
        addSubview(healthsettingButton)
    }
    
    private func setConstraints() {
        
        userRecommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(12)
        }
        
        storeRecommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        healthsettingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
            $0.width.equalTo(89)
        }
    }
}
