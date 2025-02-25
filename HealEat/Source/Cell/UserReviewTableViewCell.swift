// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class UserReviewTableViewCell: UITableViewCell {
    
    var imageModels: [ImageModel] = []
    var presentImageViewer: (([ImageModel], Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
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
        imageView.layer.cornerRadius = 18
        return imageView
    }()
    
    lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var profilePurposeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    lazy var profilePurposeButton: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var reviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reviewStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        starsView.isUserInteractionEnabled = false
        return starsView
    }()
    
    lazy var reviewDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .healeatGray5
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .healeatBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private func addComponents() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileView)
        mainStackView.addArrangedSubview(reviewView)
        mainStackView.addArrangedSubview(reviewLabel)
        mainStackView.addArrangedSubview(imageCollectionView)
        
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileNameLabel)
        profileView.addSubview(profilePurposeLabel)
        profileView.addSubview(profilePurposeButton)
        
        reviewView.addSubview(reviewStarsView)
        reviewView.addSubview(reviewDateLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(16)
        })
        profileImageView.snp.makeConstraints({ make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(36)
        })
        profileNameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.top.equalToSuperview()
        })
        profilePurposeLabel.snp.makeConstraints({ make in
            make.top.equalTo(profileNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(profileView.snp.centerX)
            make.bottom.equalToSuperview()
        })
        profilePurposeButton.snp.makeConstraints({ make in
            make.edges.equalTo(profilePurposeLabel)
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
        imageCollectionView.snp.makeConstraints({ make in
            make.height.equalTo(108)
            make.leading.trailing.equalToSuperview()
        })
    }
    
    func updateCollectionViewVisibility(isVisible: Bool) {
        imageCollectionView.snp.updateConstraints({ make in
            make.height.equalTo(isVisible ? 108 : 0)
        })
    }
}

extension UserReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.previewImageView.kf.setImage(with: imageModels[indexPath.row].imageUrl)
        cell.previewImageView.layer.cornerRadius = 6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 108)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentImageViewer?(imageModels, indexPath.row)
    }
}
