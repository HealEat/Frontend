// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

class MyHealthInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "나의 건강 목표"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private let healthGoalsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    private let tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    private func setViews() {
        
        addSubview(titleLabel)
        addSubview(healthGoalsStackView)
        addSubview(tagStackView)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(122.5)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(21)
        }
        
        healthGoalsStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.height.equalTo(27)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(33)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
    }
    
    func updateUI(with healthInfo: MyHealthInfoResponse) {
        healthGoalsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if !healthInfo.healthGoals.isEmpty {
            for goal in healthInfo.healthGoals {
                let goalButton = createGoalButton(title: goal)
                healthGoalsStackView.addArrangedSubview(goalButton)
            }
        }
        
        if !healthInfo.vegetarianType.isEmpty {
            addTagSection(title: "비건 종류", tags: [healthInfo.vegetarianType])
        }
        if !healthInfo.healthIssues.isEmpty {
            addTagSection(title: "질병으로 인한 건강 상의 불편함", tags: healthInfo.healthIssues)
        }
        if !healthInfo.requiredMeals.isEmpty {
            addTagSection(title: "나에게 필요한 식사", tags: healthInfo.requiredMeals)
        }
        if !healthInfo.requiredNutrients.isEmpty {
            addTagSection(title: "나에게 필요한 영양소", tags: healthInfo.requiredNutrients)
        }
        if !healthInfo.avoidedFoods.isEmpty {
            addTagSection(title: "피해야 하는 음식", tags: healthInfo.avoidedFoods)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // 태그 섹션 추가
    private func addTagSection(title: String, tags: [String]) {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        sectionLabel.textColor = .black
        
        let tagStack = UIStackView()
        tagStack.axis = .horizontal
        tagStack.spacing = 6
        tagStack.alignment = .leading
        
        for tag in tags {
            let tagLabel = createTagButton(title: tag)
            tagStack.addArrangedSubview(tagLabel)
        }
        
        let sectionStack = UIStackView(arrangedSubviews: [sectionLabel, tagStack])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        tagStackView.addArrangedSubview(sectionStack)
    }
    
    private func createTagButton(title: String) -> UIButton {
        let button = DynamicTagButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "009459"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = UIColor(hex: "EEFAF5")
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.sizeToFit()
        return button
    }
    
    private func createGoalButton(title: String) -> UIButton {
        let button = DynamicTagButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "009459"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = UIColor(hex: "EEFAF5")
        button.layer.borderColor = UIColor(hex: "C4E9BE")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = false
        button.sizeToFit()
        return button
    }
}

class DynamicTagButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 22, height: size.height + 12) // 패딩 적용
    }
}
