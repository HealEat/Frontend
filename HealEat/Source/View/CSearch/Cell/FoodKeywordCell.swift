// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FoodKeywordCell: UICollectionViewCell {
    static let identifier = "FoodKeywordCell"
    
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.healeatGray6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .healeatGray2P5
        contentView.addSubview(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // ✅ `isSelected` 상태가 아니라, `updateUI(isSelected:)`로 UI를 직접 업데이트
    func updateUI(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = .healeatLightGreen // 선택 배경색
            label.textColor = .healeatGreen1 // 선택 글씨색
            label.font = .systemFont(ofSize: 12, weight: .medium)
        } else {
            contentView.backgroundColor = .healeatGray2P5 // 원래 배경색
            label.textColor = .healeatGray6 // 원래 글씨색
            label.font = .systemFont(ofSize: 12, weight: .regular)
        }
    }
}
