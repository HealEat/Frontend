// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class KeywordChipsView: UIView {

    // MARK: - UI Properties
    let separator1 = UIView().then { line in
        line.backgroundColor = UIColor.healeatGray3
    }
    let separator2 = UIView().then { line in
        line.backgroundColor = UIColor.healeatGray3
    }
    let label = UILabel().then { label in
        label.text = "검색 키워드"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.healeatGray5
    }
    let allKeywordButton = UIButton().then { button in
        button.setTitle("전체 키워드 보기", for: .normal)
        button.setTitleColor(UIColor.healeatGray5, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.healeatGray3.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
    }
    let foodTypeLabel = UILabel().then { label in
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "음식 종류"
        label.textColor = UIColor.healeatGray5
    }
    let nutritionLabel = UILabel().then { label in
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "음식 특징"
        label.textColor = UIColor.healeatGray5
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
        [separator1, separator2, label, allKeywordButton, foodTypeLabel, nutritionLabel].forEach {
            addSubview($0)
        }
        separator1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        separator2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
        }
        allKeywordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(18)
            make.width.equalTo(95)
            make.height.equalTo(24)
        }
        foodTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        nutritionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(foodTypeLabel.snp.bottom).offset(30)
        }
    }
    

}
