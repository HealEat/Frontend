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
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
        let filteredFeatures = features.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        self.features = filteredFeatures

        // 배열이 비어 있으면 reloadData 호출하지 않음
        if self.features.isEmpty {
            self.isHidden = true
            self.collectionview.isHidden = true
            self.updateHeight(isEmpty: true)
            return
        }

        self.collectionview.reloadData()

        let isEmpty = filteredFeatures.isEmpty
        self.isHidden = isEmpty
        collectionview.isHidden = isEmpty

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateHeight(isEmpty: isEmpty)
        }
    }


    public func updateHeight(isEmpty: Bool) {
        DispatchQueue.main.async {
            let height = isEmpty ? 0 : self.collectionview.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint?.update(offset: height)
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }
    }
}




extension AllTagView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.isEmpty ? 0 : features.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < features.count else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodTagCell.identifier, for: indexPath) as? FoodTagCell else {
            return UICollectionViewCell()
        }

        cell.label.text = features[indexPath.row]
        return cell
    }

}
