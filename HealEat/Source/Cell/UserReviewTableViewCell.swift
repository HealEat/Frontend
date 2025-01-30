// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class UserReviewTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 6
        return stackView
    }()
    
    lazy var profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var profilePurposeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    lazy var reviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reviewStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        return starsView
    }()
    
    lazy var reviewDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatGray5
        label.font = UIFont.systemFont(ofSize: 9, weight: .light)
        return label
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        return label
    }()
    
    lazy var photoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bouncesHorizontally = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 6
        return stackView
    }()
    
    func addImage(url: URL) {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.kf.setImage(with: url)
        
        photoStackView.addArrangedSubview(imageView)
    }
    
    private func addComponents() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileView)
        mainStackView.addArrangedSubview(reviewView)
        mainStackView.addArrangedSubview(reviewLabel)
        mainStackView.addArrangedSubview(photoScrollView)
        
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileNameLabel)
        profileView.addSubview(profilePurposeLabel)
        
        reviewView.addSubview(reviewStarsView)
        reviewView.addSubview(reviewDateLabel)
        
        photoScrollView.addSubview(photoStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(16)
        })
        profileImageView.snp.makeConstraints({ make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(30)
        })
        profileNameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.top.equalToSuperview()
        })
        profilePurposeLabel.snp.makeConstraints({ make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.bottom.equalToSuperview()
        })
        reviewStarsView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(1)
            make.leading.equalToSuperview()
            make.height.equalTo(9)
        })
        reviewDateLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(reviewStarsView.snp.trailing).offset(4)
        })
//        photoScrollView.snp.makeConstraints({ make in
//            
//        })
        photoStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        })
    }
}
