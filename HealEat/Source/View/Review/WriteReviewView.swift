// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class WriteReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var navigationSafeAreaView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .healeatBlack
        return button
    }()
    
    lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .healeatBlack
        return label
    }()
    
    lazy var separatorView0: UIView = {
        let view = UIView()
        view.backgroundColor = .healeatGray3P5
        return view
    }()
    
    lazy var topReviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .healeatBlack
        return label
    }()
    
    lazy var topStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        return starsView
    }()
    
    lazy var separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .healeatGray3P5
        return view
    }()
    
    lazy var ratingReviewView: RatingReviewView = {
        let view = RatingReviewView()
        return view
    }()
    
    lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .healeatGray6
        return label
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .addPhoto), for: .normal)
        return button
    }()
    
    lazy var reviewImageView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        return collectionView
    }()
    
    lazy var reviewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.healeatGray3P5.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .healeatBlack
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()
    
    lazy var reviewSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .healeatGray3P5
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .healeatLightGreen
        button.layer.borderColor = UIColor.healeatGreen1.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 14
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.healeatGreen1, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private func addComponents() {
        self.addSubview(navigationView)
        self.addSubview(separatorView0)
        self.addSubview(topReviewView)
        self.addSubview(separatorView1)
        self.addSubview(ratingReviewView)
        self.addSubview(reviewStackView)
        
        navigationView.addSubview(navigationSafeAreaView)
        
        navigationSafeAreaView.addSubview(navigationBackButton)
        navigationSafeAreaView.addSubview(navigationTitleLabel)
        
        topReviewView.addSubview(topStackView)
        
        topStackView.addArrangedSubview(topTitleLabel)
        topStackView.addArrangedSubview(topStarsView)
        
        reviewStackView.addArrangedSubview(reviewTitleLabel)
        reviewStackView.addArrangedSubview(reviewImageView)
        reviewStackView.addArrangedSubview(reviewView)
        reviewStackView.addArrangedSubview(submitButton)
        
        reviewView.addSubview(reviewTextView)
        reviewView.addSubview(reviewSubLabel)
        
        reviewImageView.addSubview(addImageButton)
        reviewImageView.addSubview(imageCollectionView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        navigationView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        navigationSafeAreaView.snp.makeConstraints({ make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        })
        navigationBackButton.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
        })
        navigationTitleLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(navigationBackButton.snp.trailing).offset(10)
        })
        separatorView0.snp.makeConstraints({ make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        })
        topReviewView.snp.makeConstraints({ make in
            make.top.equalTo(separatorView0.snp.bottom)
            make.leading.trailing.equalToSuperview()
        })
        topStackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        })
        topStarsView.snp.makeConstraints({ make in
            make.height.equalTo(24)
        })
        separatorView1.snp.makeConstraints({ make in
            make.top.equalTo(topReviewView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        })
        ratingReviewView.snp.makeConstraints({ make in
            make.top.equalTo(separatorView1.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        })
        reviewStackView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(ratingReviewView.snp.bottom).offset(33)
        })
        reviewImageView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
        })
        addImageButton.snp.makeConstraints({ make in
            make.width.height.equalTo(50)
            make.centerX.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview().priority(500)
            make.leading.greaterThanOrEqualToSuperview()
            make.top.bottom.equalToSuperview()
        })
        imageCollectionView.snp.makeConstraints({ make in
            make.leading.equalTo(addImageButton.snp.trailing).offset(6)
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(imageCollectionView.collectionViewLayout.collectionViewContentSize.width).priority(600)
        })
        reviewView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
        })
        reviewTextView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(125)
            make.top.equalToSuperview().inset(12)
        })
        reviewSubLabel.snp.makeConstraints({ make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
        })
        submitButton.snp.makeConstraints({ make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview()
        })
    }
    
    func updateCollectionViewWidth() {
        imageCollectionView.snp.updateConstraints({ make in
            make.width.equalTo(imageCollectionView.collectionViewLayout.collectionViewContentSize.width).priority(600)
        })
    }
}
