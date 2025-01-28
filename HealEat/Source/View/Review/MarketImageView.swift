// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import CHTCollectionViewWaterfallLayout

class MarketImageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.headerHeight = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bouncesVertically = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        
        return collectionView
    }()
    
    private func addComponents() {
        self.addSubview(imageCollectionView)
        setConstraints()
    }
    
    private func setConstraints() {
        imageCollectionView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        })
    }
}
