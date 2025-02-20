// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class AllKeywordChipsView: UIView {
    
    var isFoodType = true {
        didSet {
            foodTypeButton.isSelected = isFoodType
            nutritionButton.isSelected = !isFoodType
            collectionview.isFoodType = isFoodType
        }
    }

    // MARK: - UI Properties
    lazy var collectionview = AllKeywordChipsCollectionView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var foodTypeButton = createCategoryButton(title: "음식 종류")
    private lazy var nutritionButton = createCategoryButton(title: "음식 특징")
    
    private lazy var typeStack = UIStackView(arrangedSubviews: [foodTypeButton, nutritionButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
    }

    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Methods
    private func setupUI() {
        addSubview(typeStack)
        addSubview(collectionview)
        
        typeStack.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
        }

        collectionview.snp.makeConstraints { make in
            make.top.equalTo(typeStack.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.bottom.equalToSuperview()
        }
    }

    
    private func createCategoryButton(title: String) -> UIButton {
        let button = UIButton()
        let unselected = NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor.healeatGray4P5
        ])
        let selected = NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.healeatGray6
        ])
        
        button.setAttributedTitle(unselected, for: .normal)
        button.setAttributedTitle(selected, for: .selected)
        button.addTarget(self, action: #selector(toggleButtonState), for: .touchUpInside)
        
        return button
    }
    
    @objc private func toggleButtonState() {
        isFoodType.toggle()
    }
    

}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) ->  [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0
    
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
