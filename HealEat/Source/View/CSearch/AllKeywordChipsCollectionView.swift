// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster


class AllKeywordChipsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var isFoodType = true {
        didSet { reloadData() }
    }

    private let maxSelectionCount = 5

    init() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 6
        layout.estimatedItemSize = .zero

        super.init(frame: .zero, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)

        self.register(FoodKeywordCell.self, forCellWithReuseIdentifier: FoodKeywordCell.identifier)
        self.register(AllKeywordCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isFoodType ? FoodCategory.allCases.count : NutritionCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFoodType ?
        FoodCategory.allCases[section].sections.count : NutritionCategory.allCases[section].sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell
        let (id, name) = getCategoryItemInfo(at: indexPath)
        
        cell.label.text = name

        let categoryType = isFoodType ? 0 : 1
        let isSelected = CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id)
        cell.updateUI(isSelected: isSelected)

        return cell
    }
    
    private func getCategoryItemInfo(at indexPath: IndexPath) -> (id: Int, name: String) {
        if isFoodType {
            let foodCategory = FoodCategory.allCases[indexPath.section].sections[indexPath.row]
            return (foodCategory.id, foodCategory.name)
        } else {
            let nutritionCategory = NutritionCategory.allCases[indexPath.section].sections[indexPath.row]
            return (nutritionCategory.id, nutritionCategory.name)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = isFoodType ? 0 : 1
        let (id, _) = getCategoryItemInfo(at: indexPath)
        
        updateSelection(id: id, categoryType: categoryType)
        collectionView.reloadItems(at: [indexPath])
    }


    
    private func updateSelection(id: Int, categoryType: Int) {
        if CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id) {
            CategorySelectionManager.shared.removeSelection(id, forCategory: categoryType)
        } else if CategorySelectionManager.shared.getTotalSelectedCount() < maxSelectionCount {
            CategorySelectionManager.shared.addSelection(id, forCategory: categoryType)
        } else {
            Toaster.shared.makeToast("5개 이상 선택할 수 없습니다.", .short)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = isFoodType
            ? FoodCategory.allCases[indexPath.section].sections[indexPath.row].name
            : NutritionCategory.allCases[indexPath.section].sections[indexPath.row].name

        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = item
        label.sizeToFit()

        return CGSize(width: label.frame.width + 13, height: label.frame.height + 7)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier, for: indexPath) as? AllKeywordCollectionViewHeader else {
            return UICollectionReusableView()
        }
        let title = isFoodType ? FoodCategory.allCases[indexPath.section].rawValue : NutritionCategory.allCases[indexPath.section].rawValue
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45) //  헤더 높이
    }

}
