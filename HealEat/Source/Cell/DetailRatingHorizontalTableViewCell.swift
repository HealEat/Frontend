// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DetailRatingHorizontalCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .healeatGray6
    }
    
    lazy var starImageView = UIImageView().then {
        $0.image = UIImage(resource: .star).withTintColor(.healeatGreen2, renderingMode: .alwaysOriginal)
    }
    
    lazy var scoreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .healeatDarkGreen2
    }
    
    private func addComponents() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(scoreLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({ make in
            make.top.bottom.leading.equalToSuperview()
        })
        starImageView.snp.makeConstraints({ make in
            make.height.width.equalTo(11)
            make.top.bottom.equalToSuperview().inset(1)
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
        })
        scoreLabel.snp.makeConstraints({ make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(starImageView.snp.trailing).offset(2)
        })
    }
}
