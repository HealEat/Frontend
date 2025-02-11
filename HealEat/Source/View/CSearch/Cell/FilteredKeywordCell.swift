// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FilteredKeywordCell: UICollectionViewCell {
    static let identifier = "FilteredKeywordCell"
    var categoryType: Int? // foodType 0, nutritionType 1
    
    public lazy var filterLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .healeatGreen1
    }
    public lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .healeatGreen1
    }
    
    private lazy var stack = UIStackView(arrangedSubviews: [filterLabel, deleteButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 1
        $0.alignment = .center
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
        contentView.backgroundColor = .healeatLightGreen
        
        contentView.addSubview(stack)
    }
    
    private func setConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(12)
        }
        deleteButton.setContentHuggingPriority(.defaultHigh, for: .vertical)

    }
    
    func configure(with name: String, id: Int, categoryType: Int, target: Any?, action: Selector) {
        filterLabel.text = name
        deleteButton.tag = id // ✅ ID 저장
        deleteButton.accessibilityHint = "\(categoryType)" // ✅ Category 저장 (String 변환 후 저장)
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
    }

}
