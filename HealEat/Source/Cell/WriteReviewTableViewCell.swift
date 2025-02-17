// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class WriteReviewTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var reviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .healeatBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var reviewStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatYellow, baseColor: .healeatGray4)
        starsView.isUserInteractionEnabled = false
        return starsView
    }()
    
    lazy var reviewMoreButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        configuration.background.backgroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("건강 후기 남기러 가기", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.healeatGray5,
        ]))
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.layer.borderColor = UIColor.healeatGray3P5.cgColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private func addComponents() {
        contentView.addSubview(reviewView)
        
        reviewView.addSubview(reviewStackView)
        
        reviewStackView.addArrangedSubview(reviewTitleLabel)
        reviewStackView.addArrangedSubview(reviewStarsView)
        reviewStackView.addArrangedSubview(reviewMoreButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        reviewView.snp.makeConstraints({ make in
            make.top.leading.trailing.bottom.equalToSuperview()
        })
        reviewStackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        })
        reviewStarsView.snp.makeConstraints({ make in
            make.height.equalTo(24)
        })
    }
}
