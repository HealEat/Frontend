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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var storeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
        $0.setImage(UIImage(systemName: "scrapimage"), for: .normal)
    }
    
    private lazy var starImage = UIButton().then {
        $0.setImage(UIImage(systemName: "starimage"), for: .normal)
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 1.00)
        $0.text = "4.0 (23)"
        $0.numberOfLines = 0
    }
    
    private lazy var scorelist = UIButton().then {
        $0.setImage(UIImage(systemName: "별점 리스트"), for: .normal)
    }
    
    private lazy var foodtag = UIButton().then {
        $0.setImage(UIImage(systemName: "foodtag"), for: .normal)
    }
    
    private func setViews() {
        addSubview(storeImage)
        addSubview(storenameLabel)
        addSubview(foodnameLabel)
        addSubview(scrapButton)
        addSubview(starImage)
        addSubview(scoreLabel)
        addSubview(scorelist)
        addSubview(foodtag)
        
    }
    
    public func loadImage(from url: String) {
        if let imageURL = URL(string: url) {
            storeImage.kf.setImage(with: imageURL)
        }
    }
    
    private func setConstaints() {
        
        storeImage.snp.makeConstraints {
            $0.width.height.equalTo(95)
            $0.leading.equalToSuperview().offset(13)
            $0.top.equalToSuperview().offset(14)
        }
        
        storenameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(storeImage.snp.trailing).offset(12)
            $0.height.equalTo(19)
        }
        
        foodnameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalTo(storenameLabel.snp.trailing).offset(6)
            $0.height.equalTo(16)
        }
        
        scrapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.top.equalToSuperview().offset(21)
            $0.width.equalTo(9)
            $0.height.equalTo(13)
        }
        
        starImage.snp.makeConstraints {
            $0.top.equalTo(storenameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(storeImage.snp.trailing).offset(14)
            $0.height.equalTo(11)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(storenameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(starImage.snp.trailing).offset(6)
            $0.height.equalTo(13)
        }
        
        scorelist.snp.makeConstraints {
            $0.top.equalTo(starImage.snp.bottom).offset(8.5)
            $0.leading.equalTo(storeImage.snp.trailing).offset(12)
            $0.height.equalTo(13)
        }
        
        foodtag.snp.makeConstraints {
            $0.top.equalTo(scorelist.snp.bottom).offset(8)
            $0.leading.equalTo(storeImage.snp.trailing).offset(12)
            $0.height.equalTo(19)
        }
        
    }
        
    public func storeconfigure(model: StoreResponse) {
        self.loadImage(from: model.imageUrlList.first ?? "")
        self.storenameLabel.text = model.place_name
        self.foodnameLabel.text = model.category_name
        self.scrapButton.setImage(UIImage(systemName: "scrapimage"), for: .normal)
        self.starImage.setImage(UIImage(systemName: "starimage"), for: .normal)
        self.scoreLabel.text = "\(model.totalScore) (\(model.reviewCount))"
        self.scorelist.setImage(UIImage(systemName: "starlist"), for: .normal)
        self.foodtag.setImage(UIImage(systemName: "foodtag"), for: .normal)
    }
        
}

