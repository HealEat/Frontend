// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import CHTCollectionViewWaterfallLayout

class MarketHomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
    
    lazy var imagePreviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 16
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        
        return collectionView
    }()
    
    lazy var imageMoreButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        configuration.background.backgroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("사진 더보기", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1),
        ]))
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.layer.borderColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1).cgColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1)
        return view
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var reviewStarsView: StarsView = {
        let starsView = StarsView(accentColor: UIColor(red: 255/255, green: 207/255, blue: 48/255, alpha: 1), baseColor: UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1))
        return starsView
    }()
    
    lazy var reviewMoreButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        configuration.background.backgroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("건강 후기 남기러 가기", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1),
        ]))
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.layer.borderColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1).cgColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    private func addComponents() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(imagePreviewView)
        contentView.addSubview(separatorView)
        contentView.addSubview(reviewView)
        
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
        
        imagePreviewView.addSubview(imageCollectionView)
        imagePreviewView.addSubview(imageMoreButton)
        
        reviewView.addSubview(reviewStackView)
        
        reviewStackView.addArrangedSubview(reviewTitleLabel)
        reviewStackView.addArrangedSubview(reviewStarsView)
        reviewStackView.addArrangedSubview(reviewMoreButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainScrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
//            make.height.equalTo(3000)
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
        imagePreviewView.snp.makeConstraints({ make in
            make.top.equalTo(infoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        })
        imageCollectionView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(32)
            make.height.equalTo(390)
        })
        imageMoreButton.snp.makeConstraints({ make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        })
        separatorView.snp.makeConstraints({ make in
            make.top.equalTo(imagePreviewView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        })
        reviewView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom)
        })
        reviewStackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        })
        reviewStarsView.snp.makeConstraints({ make in
            make.height.equalTo(13)
        })
    }
}
