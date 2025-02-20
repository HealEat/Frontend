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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBookmarkStatus(_:)),
            name: NSNotification.Name("BookmarkUpdated"),
            object: nil
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        storeImage.image = nil
        storenameLabel.text = nil
        foodnameLabel.text = nil
        mainratingLabel.text = nil
        reviewCountLabel.text = nil
        features = []
        isBookmarkUpdated = nil
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
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
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(resource: .bookmark), for: .normal)
        button.setImage(UIImage(resource: .bookmarkFill), for: .selected)
        button.tintColor = .healeatBlack
        return button
    }()
    
    private lazy var mainratingStarView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        starsView.isUserInteractionEnabled = false
        return starsView
    }()
    
    private lazy var mainratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .healeatGray5
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .healeatGray5
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var noreviewLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00)
        $0.text = "등록된 리뷰가 없습니다."
        $0.numberOfLines = 0
    }
    
    private lazy var alltagView = AllTagView().then {
        $0.backgroundColor = .white
        $0.collectionview.delegate = self
        $0.collectionview.dataSource = self
        $0.collectionview.register(FoodTagCell.self, forCellWithReuseIdentifier: FoodTagCell.identifier)
        $0.collectionview.isUserInteractionEnabled = true
    }
    
    private var features: [String] = []
    private var isBookmarkUpdated: Bool?
    private var placeId: Int?
    
    private func setViews() {
        addSubview(storeImage)
        addSubview(storenameLabel)
        addSubview(foodnameLabel)
        addSubview(bookmarkButton)
        addSubview(mainratingStarView)
        addSubview(mainratingLabel)
        addSubview(reviewCountLabel)
        addSubview(noreviewLabel)
        addSubview(categoryStackView)
        addSubview(alltagView)
    }
    
    private func setConstaints() {
        
        storenameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
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
            $0.leading.equalToSuperview().offset(14)
            $0.top.equalTo(storenameLabel.snp.bottom).offset(12)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalToSuperview().offset(14)
            $0.width.equalTo(15)
            $0.height.equalTo(19)
        }
        
        noreviewLabel.snp.makeConstraints {
             $0.top.equalTo(storenameLabel.snp.bottom).offset(18)
             $0.leading.equalTo(storeImage.snp.trailing).offset(12)
        }
        
        mainratingStarView.snp.makeConstraints({ make in
            make.leading.equalTo(storeImage.snp.trailing).offset(12)
            make.top.equalTo(storenameLabel.snp.bottom).offset(19)
            make.height.equalTo(11)
        })
        
        mainratingLabel.snp.makeConstraints {
            $0.leading.equalTo(mainratingStarView.snp.trailing).offset(6)
            $0.centerY.equalTo(mainratingStarView)
        }
        
        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(mainratingLabel.snp.trailing).offset(3)
            $0.centerY.equalTo(mainratingStarView)
        }

        categoryStackView.snp.makeConstraints {
            $0.leading.equalTo(storeImage.snp.trailing).offset(12)
            $0.top.equalTo(mainratingStarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        alltagView.snp.makeConstraints {
            $0.leading.equalTo(storeImage.snp.trailing)
            $0.top.equalTo(categoryStackView.snp.bottom).offset(8)
            $0.height.equalTo(45)
            $0.trailing.equalToSuperview().offset(-5)
        }
    }

    public func storeconfigure(model: StoreResponse) {
        self.placeId = model.id
        self.features = []
        alltagView.collectionview.reloadData()
        
        if let imageUrl = model.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
            self.storeImage.kf.setImage(with: url, placeholder: UIImage(named: "notimage"))
        } else {
            self.storeImage.image = UIImage(named: "notimage") // 기본 이미지 설정
        }
        
        self.storenameLabel.text = model.place_name
        self.foodnameLabel.text = model.category_name


        if let scoreInfo = model.isInDBInfo, scoreInfo.totalHealthScore > 0.0 {
            self.mainratingStarView.isHidden = false
            self.mainratingLabel.isHidden = false
            self.reviewCountLabel.isHidden = false
            self.noreviewLabel.isHidden = true
            
            self.mainratingStarView.star = scoreInfo.totalHealthScore
            self.mainratingLabel.text = String(format: "%.1f", scoreInfo.totalHealthScore)
            self.reviewCountLabel.text = "(\(scoreInfo.reviewCount))"
    
        } else {
            self.mainratingStarView.isHidden = true
            self.mainratingLabel.isHidden = true
            self.reviewCountLabel.isHidden = true
            self.noreviewLabel.isHidden = false
        }
        
        if let scoreInfo = model.isInDBInfo, scoreInfo.totalHealthScore > 0.0 {
            categoryStackView.addArrangedSubview(createCategoryView(category: "질병 관리", score: Double(scoreInfo.sickScore)))
            categoryStackView.addArrangedSubview(createCategoryView(category: "베지테리언", score: Double(scoreInfo.vegetScore)))
            categoryStackView.addArrangedSubview(createCategoryView(category: "다이어트", score: Double(scoreInfo.dietScore)))
            
            self.categoryStackView.isHidden = false
        } else {
            self.categoryStackView.isHidden = true
        }
        self.features = model.features
        self.alltagView.updateTags(features: model.features)
        
        if let isUpdated = isBookmarkUpdated {
            bookmarkButton.isSelected = isUpdated
        } else {
            bookmarkButton.isSelected = model.bookmarkId != nil && model.bookmarkId != 0
        }
        
        DispatchQueue.main.async {
            self.storeImage.setNeedsLayout()
            self.storeImage.layoutIfNeeded()
            self.alltagView.collectionview.reloadData()
            self.alltagView.collectionview.collectionViewLayout.invalidateLayout()
            self.alltagView.collectionview.layoutIfNeeded()
        }
    }
    
    private func createCategoryView(category: String, score: Double) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
            
        let starIcon = UIImageView(image: UIImage(resource: .star).withTintColor(.healeatGreen2, renderingMode: .alwaysOriginal))
        starIcon.snp.makeConstraints { $0.width.height.equalTo(11) }

        let scoreLabel = UILabel()
        scoreLabel.text = String(format: "%.1f", score)
        scoreLabel.font = .systemFont(ofSize: 11)
        scoreLabel.textColor = .healeatDarkGreen2

        let categoryLabel = UILabel()
        categoryLabel.text = category
        categoryLabel.font = .systemFont(ofSize: 11)
        categoryLabel.textColor = .healeatGray6

        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(starIcon)
        stackView.addArrangedSubview(scoreLabel)

        return stackView
    }
    
    @objc private func updateBookmarkStatus(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
        let updatedPlaceId = userInfo["placeId"] as? Int,
        let newBookmarkState = userInfo["isBookmarked"] as? Bool else { return }

        if self.placeId == updatedPlaceId {
            DispatchQueue.main.async {
                self.isBookmarkUpdated = newBookmarkState //  북마크 상태 저장
                self.bookmarkButton.isSelected = newBookmarkState
            }
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

extension UIImage {
    func resizedImage(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

