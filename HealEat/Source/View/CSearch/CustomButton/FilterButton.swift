// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class FilterButton: UIButton {
    var isSelectedState: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    private func updateStyle() {
        if isSelectedState {
            self.backgroundColor = UIColor.healeatLightGreen
            self.setTitleColor(UIColor.healeatGreen1, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        } else {
            self.backgroundColor = UIColor.healeatGray2P5
            self.setTitleColor(UIColor.healeatGray6, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        updateStyle()
        
        self.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(titleLabel?.snp.width ?? 70).offset(10) // titleLabel 너비 + 여백 추가
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
