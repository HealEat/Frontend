// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class NoReviewTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "등록된 리뷰가 없습니다."
        label.textAlignment = .center
        return label
    }()
    
    private func addComponents() {
        contentView.addSubview(mainLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        mainLabel.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        })
    }
}
