// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class EmptyStateCell: UICollectionViewCell {
    static let identifier = "EmptyStateCell"
    
    private let messageLabel = UILabel().then {
        $0.textColor = .healeatGray5
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.text = "검색 결과 없음."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
