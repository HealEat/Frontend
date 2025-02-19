// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then
import Kingfisher

class StoreCollectionViewCell: UICollectionViewCell {
    static let identifier = "StoreCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstaints()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        storeImage.image = nil
        storenameLabel.text = nil
        foodnameLabel.text = nil
        scoreLabel.text = nil
        features = []
        alltagView.collectionview.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private lazy var storeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(hex: "CFCFCF")
    }
    
    private lazy var storenameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
        $0.text = "본죽&비빔밤cafe 홍대점"
        $0.numberOfLines = 0
    }
    
    private lazy var foodnameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 1.00)
        $0.text = "죽"
        $0.numberOfLines = 0
    }
    
    private lazy var scrapButton = UIButton().then {
        $0.setImage(UIImage(named: "scrapimage"), for: .normal)
    }
    
    private lazy var starImage = UIButton().then {
        $0.setImage(UIImage(named: "starimage"), for: .normal)
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 1.00)
        $0.text = "4.0 (23)"
        $0.numberOfLines = 0
    }
    
    private lazy var scorelist = UIButton().then {
        $0.setImage(UIImage(named: "별점 리스트"), for: .normal)
    }
    
    private lazy var alltagView = AllTagView().then {
        $0.backgroundColor = .white
        $0.collectionview.delegate = self
        $0.collectionview.dataSource = self
        $0.collectionview.register(FoodTagCell.self, forCellWithReuseIdentifier: FoodTagCell.identifier)
        $0.collectionview.isUserInteractionEnabled = true
    }

    private var features: [String] = []
    
    private func setViews() {
        addSubview(storeImage)
        addSubview(storenameLabel)
        addSubview(foodnameLabel)
        addSubview(scrapButton)
        addSubview(starImage)
        addSubview(scoreLabel)
        addSubview(scorelist)
        addSubview(alltagView)
    }
    
    private func setConstaints() {
        
        storenameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(19)
        }
        
        foodnameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(storenameLabel.snp.trailing).offset(6)
            $0.height.equalTo(16)
            $0.width.lessThanOrEqualTo(80)
        }
        
        storeImage.snp.makeConstraints {
            $0.width.height.equalTo(95)
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(storenameLabel.snp.bottom).offset(12)
        }
        
        scrapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalToSuperview().offset(17)
            $0.width.equalTo(15)
            $0.height.equalTo(13)
        }
        
        starImage.snp.makeConstraints {
            $0.top.equalTo(storenameLabel.snp.bottom).offset(18)
            $0.leading.equalTo(storeImage.snp.trailing).offset(14)
            $0.height.equalTo(15)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(storenameLabel.snp.bottom).offset(17.5)
            $0.leading.equalTo(starImage.snp.trailing).offset(6)
            $0.height.equalTo(15)
        }
        
        scorelist.snp.makeConstraints {
            $0.top.equalTo(starImage.snp.bottom).offset(8)
            $0.leading.equalTo(storeImage.snp.trailing).offset(12)
            $0.height.equalTo(15)
        }
        
        alltagView.snp.makeConstraints {
            $0.leading.equalTo(storeImage.snp.trailing)
            $0.top.equalTo(scorelist.snp.bottom).offset(8)
            $0.height.equalTo(50)
            $0.trailing.equalToSuperview().offset(-5)
        }
    }
        
    public func storeconfigure(model: StoreResponse) {
        
        self.features = []
        alltagView.collectionview.reloadData()
        
        if let imageUrl = model.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
            self.storeImage.kf.setImage(with: url, placeholder: UIImage(named: "notimage"))
        } else {
            self.storeImage.image = UIImage(named: "notimage") // 기본 이미지 설정
        }
        
        self.storenameLabel.text = model.place_name
        self.foodnameLabel.text = model.category_name
        self.scrapButton.setImage(UIImage(named: "scrapimage"), for: .normal)
        self.starImage.setImage(UIImage(named: "starimage"), for: .normal)
        if let scoreInfo = model.isInDBInfo {
            self.scoreLabel.text = "\(scoreInfo.totalHealthScore) (\(scoreInfo.reviewCount))"
        } else {
            self.scoreLabel.text = "등록된 리뷰가 없습니다."
        }
        self.scorelist.setImage(UIImage(named: "starlist"), for: .normal)
        
        self.features = model.features
        self.alltagView.updateTags(features: model.features)
        
        DispatchQueue.main.async {
            self.storeImage.setNeedsLayout()
            self.storeImage.layoutIfNeeded()
            self.alltagView.collectionview.reloadData()
            self.alltagView.collectionview.collectionViewLayout.invalidateLayout()
            self.alltagView.collectionview.layoutIfNeeded()
        }
    }
        
}

extension StoreCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodTagCell.identifier, for: indexPath) as? FoodTagCell else {
            return UICollectionViewCell()
        }
        cell.label.text = features[indexPath.row]
        return cell
    }
}

