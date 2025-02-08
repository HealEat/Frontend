// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class NotloginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var loginRecommendLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00)
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.text = "로그인하여 건강 맞춤 매장을\n 추천 받아보세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    public lazy var gotologinButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00).cgColor
        $0.backgroundColor = .clear
        $0.setTitle("로그인 하러 가기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00) , for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    private func setViews() {
        addSubview(loginRecommendLabel)
        addSubview(gotologinButton)
    }
    
    private func setConstraints() {
        
        loginRecommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        gotologinButton.snp.makeConstraints {
            $0.top.equalTo(loginRecommendLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.equalTo(80)
        }
    }
}
