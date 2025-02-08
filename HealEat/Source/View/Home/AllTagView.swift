// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then
class AllTagView: UIView {
    
    private var features: [String] = []
    
    // MARK: - UI Properties
    public lazy var collectionview = UICollectionView(
        frame: .zero,
        collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 4
            $0.minimumInteritemSpacing = 4
            $0.estimatedItemSize = CGSize(width: 60, height: 19)
        }
    ).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodTagCell.self, forCellWithReuseIdentifier: FoodTagCell.identifier)
    }

    private var collectionViewHeightConstraint: Constraint?
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
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
    
    public func updateTags(features: [String]) {
        self.features = features
        self.collectionview.reloadData()
        updateHeight() // 높이 업데이트
    }

    public func updateHeight() {
        DispatchQueue.main.async {
            let height = self.collectionview.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint?.update(offset: height)
            self.layoutIfNeeded()
        }
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}


extension AllTagView: UICollectionViewDelegate, UICollectionViewDataSource {
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
