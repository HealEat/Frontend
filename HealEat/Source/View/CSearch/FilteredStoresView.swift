// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FilteredStoresView: UIView {
    private var storeCollectionViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.storeCollectionView.reloadData() // 강제 리로드
            self.storeCollectionView.layoutIfNeeded() // 강제 레이아웃 업데이트
            
            let height = self.storeCollectionView.contentSize.height

            self.storeCollectionViewHeightConstraint?.update(offset: height)
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var setByUserInfoButton = DropDownSearchButton().then {
        $0.buttonLabel.text = "별점 순"
    }
    private lazy var setByResultButton = DropDownSearchButton().then {
        $0.buttonLabel.text = "거리 순"
    }
    
    private lazy var setButtonStack = UIStackView(arrangedSubviews: [setByUserInfoButton, setByResultButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
        $0.alignment = .center
    }
    
    public lazy var filterButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.healeatGray6.cgColor
        $0.backgroundColor = .white
        $0.setTitle("필터", for: .normal)
        $0.setTitleColor(UIColor.healeatGray6 , for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
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
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2  // ✅ 그림자 투명도 (0 ~ 1)
        self.layer.shadowOffset = CGSize(width: 10, height: 10)  // ✅ 그림자 위치
        self.layer.shadowRadius = 20  // ✅ 그림자 퍼짐 정도
        self.layer.masksToBounds = false  // ✅ 부모 뷰 바운드에 의해 그림자가 잘리는 것 방지
        
        addSubview(setButtonStack)
        addSubview(filterButton)
        addSubview(storeCollectionView)
    }
    
    private func setConstraints() {
        setButtonStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(13)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-19)
            $0.height.equalTo(20)
            $0.width.equalTo(32)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(setButtonStack.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            //storeCollectionViewHeightConstraint = $0.height.equalTo(1).constraint // 초기 높이를 1로 설정
            storeCollectionViewHeightConstraint = $0.height.equalTo(UIScreen.main.bounds.height / 2).constraint // ✅ 초기 높이를 넉넉하게 설정

        }
    }

    
    
    public func updateCollectionViewHeight() {
        DispatchQueue.main.async {
            let collectionHeight = self.storeCollectionView.contentSize.height

            self.storeCollectionViewHeightConstraint?.update(offset: collectionHeight)
            self.layoutIfNeeded()
        }
    }


}
