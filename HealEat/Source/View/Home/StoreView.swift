// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class StoreView: UIView {
    private var storeCollectionViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = storeCollectionView.contentSize.height + 100 // 버튼, 라벨 포함
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var userRecommendLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
    }
    
    public lazy var healthsettingButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00).cgColor
        $0.backgroundColor = .clear
        $0.setTitle("건강 정보 설정하기", for: .normal)
        $0.setTitleColor(.black , for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: .regular)
    }
    
    public let storeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 123)
        $0.minimumLineSpacing = 10
        $0.scrollDirection = .vertical
    }).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.identifier)
    }
    
    private func setViews() {
        addSubview(userRecommendLabel)
        addSubview(healthsettingButton)
        addSubview(storeCollectionView)
    }
    
    private func setConstraints() {
        
        userRecommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(12)
        }
        
        healthsettingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27)
            $0.trailing.equalToSuperview().offset(-19)
            $0.height.equalTo(20)
            $0.width.equalTo(80)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(userRecommendLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    
    public func setUserRecommendLabel(name: String) {
        let fullText = "\(name)님 건강 맞춤 추천"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let range = (fullText as NSString).range(of: "\(name)")
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.00, green: 0.58, blue: 0.35, alpha: 1.00), range: range)
        userRecommendLabel.attributedText = attributedString
    }

}
