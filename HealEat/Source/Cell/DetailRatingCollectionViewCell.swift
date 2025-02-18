// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DetailRatingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .star).withTintColor(.healeatGreen2, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatDarkGreen1
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var ratingCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatDarkGreen1
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .bottom
        stackView.spacing = 2.5
        return stackView
    }()
    
    private func addComponents() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingCountLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        ratingStackView.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        })
        starImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(15)
            make.top.bottom.equalToSuperview()
        })
    }
    
    
}
