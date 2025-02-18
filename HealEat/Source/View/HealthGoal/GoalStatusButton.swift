// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class GoalStatusButton: UIButton {
    
    // ✅ 선택되지 않았을 때의 스타일
    private let normalTitleColor = UIColor.healeatGray5
    private let normalBackgroundColor = UIColor.healeatGray2
    private var selectedTitleColor = UIColor.white
    private var selectedBackgroundColor = UIColor.healeatGreen1

    // 커스텀 초기화 (버튼별 색상 설정 가능)
    init(title: String,
         selectedBackground: UIColor,
         selectedTitleColor: UIColor) {
        
        self.selectedBackgroundColor = selectedBackground
        self.selectedTitleColor = selectedTitleColor
        
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.healeatGray5.cgColor
        self.backgroundColor = backgroundColor
        self.setTitleColor(normalTitleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        addTarget(self, action: #selector(toggleState), for: .touchUpInside)
    }

    // ✅ 상태 업데이트 메서드 (선택 여부에 따라 색 변경)
    func updateState(isSelected: Bool) {
        self.isSelected = isSelected
        self.backgroundColor = isSelected ? selectedBackgroundColor : normalBackgroundColor
        self.setTitleColor(isSelected ? selectedTitleColor : normalTitleColor, for: .normal)
        self.layer.borderColor = (isSelected ? selectedTitleColor : normalTitleColor).cgColor
    }
        
    // ✅ 클릭 시 상태 토글
    @objc private func toggleState() {
        updateState(isSelected: !self.isSelected)
    }
}
