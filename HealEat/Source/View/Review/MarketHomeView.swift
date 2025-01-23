// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bouncesVertically = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var locationView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .subtract).withTintColor(UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1), renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return label
    }()
    
    lazy var openView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.fill")?.withTintColor(UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1), renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var openLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        return label
    }()
    
    lazy var openHourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
        return label
    }()
    
    lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return button
    }()
    
    lazy var linkView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .link).withTintColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("매장 정보 자세히 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
        return button
    }()
    
//    lazy var imageCollectionView: UICollectionView = {
//        
//    }
    
    private func addComponents() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(locationView)
        infoStackView.addArrangedSubview(openView)
        infoStackView.addArrangedSubview(linkView)
        
        locationView.addSubview(locationImageView)
        locationView.addSubview(locationLabel)
        
        openView.addSubview(clockImageView)
        openView.addSubview(openLabel)
        openView.addSubview(openHourLabel)
        openView.addSubview(expandButton)
        
        linkView.addSubview(linkImageView)
        linkView.addSubview(linkButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainScrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(3000)
        })
        infoStackView.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        })
        locationImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        locationLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(locationImageView.snp.trailing).offset(10)
        })
        clockImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        openLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(clockImageView.snp.trailing).offset(10)
        })
        openHourLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(openLabel.snp.trailing).offset(3)
        })
        expandButton.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(openHourLabel.snp.trailing).offset(3)
            make.width.equalTo(8)
            make.height.equalTo(4)
        })
        linkImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        linkButton.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(linkImageView.snp.trailing).offset(10)
        })
    }
}
