// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class SortDropdownCell: UITableViewCell {
    static let identifier = "SortDropdownCell"

    private let sortingLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }

    private let sortingIcon = UIImageView().then {
        $0.image = UIImage(named: "checkImage")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .healeatGreen1
    }
    
    public let separator = UIView().then {
        $0.backgroundColor = .healeatGray5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(sortingLabel)
        contentView.addSubview(sortingIcon)
        contentView.addSubview(separator)

        sortingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }

        sortingIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12) // 이미지 크기 조절
        }
        
        separator.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(text: String, isSelected: Bool) {
        sortingLabel.text = text
        
        if isSelected {
            sortingLabel.textColor = .healeatGreen1
            sortingIcon.isHidden = false  // ✅ 선택된 경우 아이콘 보이게
        } else {
            sortingLabel.textColor = .healeatGray6
            sortingIcon.isHidden = true   // ✅ 선택되지 않으면 아이콘 숨김
        }
    }
}
