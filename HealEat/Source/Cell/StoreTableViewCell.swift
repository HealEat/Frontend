// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    private var featureCollectionViewHandler: FeatureCollectionViewHandler = FeatureCollectionViewHandler()
    private var detailRatingHorizontalCollectionViewHandler: DetailRatingHorizontalCollectionViewHandler = DetailRatingHorizontalCollectionViewHandler(detailRatings: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        
        featureCollectionView.delegate = featureCollectionViewHandler
        featureCollectionView.dataSource = featureCollectionViewHandler
        
        detailScoreCollectionView.delegate = detailRatingHorizontalCollectionViewHandler
        detailScoreCollectionView.dataSource = detailRatingHorizontalCollectionViewHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    lazy var mainImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
    }
    
    lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    lazy var titleView = UIView()
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .healeatBlack
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .healeatGray5
    }
    
    lazy var trashButton = UIButton().then {
        $0.setImage(UIImage(resource: .trash), for: .normal)
    }
    
    lazy var scoreView = UIView()
    
    lazy var starsView = StarsView(accentColor: .healeatYellow, baseColor: .healeatGray4)
    
    lazy var scoreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .healeatGray5
    }
    
    lazy var detailScoreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 20, height: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(DetailRatingHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DetailRatingHorizontalCollectionViewCell.self))
        
        return collectionView
    }()
    
    lazy var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 20, height: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(FeatureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: FeatureCollectionViewCell.self))
        
        return collectionView
    }()
    
    private func addComponents() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleView)
        mainStackView.addArrangedSubview(scoreView)
        mainStackView.addArrangedSubview(detailScoreCollectionView)
        mainStackView.addArrangedSubview(featureCollectionView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleView.addSubview(trashButton)
        
        scoreView.addSubview(starsView)
        scoreView.addSubview(scoreLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(95)
        })
        mainStackView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(mainImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        })
        titleLabel.snp.makeConstraints({ make in
            make.top.bottom.leading.equalToSuperview()
        })
        subtitleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.bottom.equalToSuperview()
        })
        trashButton.snp.makeConstraints({ make in
            make.top.bottom.trailing.equalToSuperview()
        })
        starsView.snp.makeConstraints({ make in
            make.height.equalTo(11)
            make.leading.top.bottom.equalToSuperview()
        })
        scoreLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starsView.snp.trailing).offset(6)
        })
        detailScoreCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(13)
        })
        featureCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(19)
        })
    }
    
//    func configure(storeResponseModel: StoreResponseModel) {
//        mainImageView.kf.setImage(with: storeResponseModel.imageUrls.first)
//        titleLabel.text = storeResponseModel.placeName
//        subtitleLabel.text = storeResponseModel.categoryName
//        starsView.star = storeResponseModel.totalScore
//        scoreLabel.text = "\(storeResponseModel.totalScore) (\(storeResponseModel.reviewCount))"
//        detailRatingHorizontalCollectionViewHandler.detailRatings = [
//            ("질병 관리", storeResponseModel.sickScore, storeResponseModel.sickCount),
//            ("베지터리언", storeResponseModel.vegetScore, storeResponseModel.vegetCount),
//            ("다이어트", storeResponseModel.dietScore, storeResponseModel.dietCount),
//        ]
//        detailScoreCollectionView.reloadData()
//        featureCollectionViewHandler.features = storeResponseModel.features
//        featureCollectionView.reloadData()
//    }
}
