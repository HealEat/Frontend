// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then
class AllTagView: UIView {

    // MARK: - UI Properties
    public lazy var collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodTagCell.self, forCellWithReuseIdentifier: FoodTagCell.identifier)
    }


    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        [collectionview,].forEach {
            addSubview($0)
        }
        
        collectionview.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
        
    }
    

}
