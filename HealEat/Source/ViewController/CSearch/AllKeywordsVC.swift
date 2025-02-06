// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class AllKeywordsVC: UIViewController {
    let foodTypeList = FoodCategory.allItems
    let nutritionList = NutritionCategory.allItems
    var isFoodType = true
        
    
    // MARK: - UI Components
    private lazy var customBackButton = UIButton().then {
        let image = UIImage(systemName: "lessthan")?.withRenderingMode(.alwaysTemplate)
        $0.setBackgroundImage(image, for: .normal)
        $0.tintColor = UIColor.healeatGray4
        $0.imageView?.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    private lazy var searchBar = CustomSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.healeatGray5,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        $0.searchBar.attributedPlaceholder = NSAttributedString(string: "음식, 매장, 주소 검색", attributes: attributes)
    }
    private lazy var foodTypeButton = UIButton().then {
        let unselected = NSAttributedString(string: "음식 종류", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(hex: "A3A3A3") ?? UIColor.healeatGray5
        ])
        let selected = NSAttributedString(string: "음식 종류", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.healeatGray6
        ])
        $0.setAttributedTitle(unselected, for: .normal)
        $0.setAttributedTitle(selected, for: .selected)
        $0.addTarget(self, action: #selector(toggleButtonState), for: .touchUpInside)
    }
    private lazy var nutritionButton = UIButton().then {
        let unselected = NSAttributedString(string: "음식 특징", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(hex: "A3A3A3") ?? UIColor.healeatGray5
        ])
        let selected = NSAttributedString(string: "음식 특징", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.healeatGray6
        ])
        $0.setAttributedTitle(unselected, for: .normal)
        $0.setAttributedTitle(selected, for: .selected)
        $0.addTarget(self, action: #selector(toggleButtonState), for: .touchUpInside)
    }
    private lazy var typeStack = UIStackView(arrangedSubviews: [foodTypeButton, nutritionButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
    }
    private lazy var allKeywordsView = AllKeywordChipsView().then {
        $0.backgroundColor = .white
        $0.collectionview.delegate = self
        $0.collectionview.dataSource = self
        $0.collectionview.register(AllKeywordCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier)
        $0.collectionview.isUserInteractionEnabled = true
    }
    
    
    
    private lazy var foodTypeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 6
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodKeywordCell.self, forCellWithReuseIdentifier: FoodKeywordCell.identifier)
        $0.register(AllKeywordCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier)
        $0.dataSource = self
        $0.delegate = self
    }

    private lazy var nutritionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 6
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodKeywordCell.self, forCellWithReuseIdentifier: FoodKeywordCell.identifier)
        $0.register(AllKeywordCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier)
        $0.dataSource = self
        $0.delegate = self
    }

 

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    



    // MARK: - UI Methods
    private func setupUI() {
        view.backgroundColor = .white
        [customBackButton, searchBar, typeStack, allKeywordsView].forEach {
            view.addSubview($0)
        }
        foodTypeButton.isSelected = true
        nutritionButton.isSelected = false
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        customBackButton.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(customBackButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(50)
        }
        typeStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
        }
        allKeywordsView.snp.makeConstraints { make in
            make.top.equalTo(typeStack.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        
    }
    
    //MARK: Setup Actions
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleButtonState() {
        foodTypeButton.isSelected.toggle()
        nutritionButton.isSelected.toggle()
        isFoodType.toggle()
        allKeywordsView.collectionview.reloadData()
    }

    
    //MARK: API call

}


extension AllKeywordsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFoodType {
            return FoodCategory.allCases.count
        } else {
            return NutritionCategory.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFoodType {
            return FoodCategory.allCases[section].sections.count
        } else {
            return NutritionCategory.allCases[section].sections.count
        }
    }


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell
        
        let category: Any
        if isFoodType {
            category = FoodCategory.allCases[indexPath.section] // ✅ 음식 카테고리
        } else {
            category = NutritionCategory.allCases[indexPath.section] // ✅ 영양소 카테고리
        }
            
        let item: String
        if let foodCategory = category as? FoodCategory {
            item = foodCategory.sections[indexPath.row]
        } else if let nutritionCategory = category as? NutritionCategory {
            item = nutritionCategory.sections[indexPath.row]
        } else {
            item = ""
        }
        
        // ✅ 셀에 데이터 적용
        cell.label.text = item

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category: Any
        if isFoodType {
            category = FoodCategory.allCases[indexPath.section] // ✅ 음식 카테고리
        } else {
            category = NutritionCategory.allCases[indexPath.section] // ✅ 영양소 카테고리
        }
            
        let item: String
        if let foodCategory = category as? FoodCategory {
            item = foodCategory.sections[indexPath.row]
        } else if let nutritionCategory = category as? NutritionCategory {
            item = nutritionCategory.sections[indexPath.row]
        } else {
            return CGSize(width: 0, height: 0) // ✅ 안전 처리 (예외 발생 방지)
        }
        var size = CGSize(width: 0, height: 0)
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.text = item
            $0.sizeToFit()
            size = $0.frame.size
        }
        return CGSize(width: size.width + 13, height: size.height + 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AllKeywordCollectionViewHeader.identifier, for: indexPath) as? AllKeywordCollectionViewHeader else { fatalError() }
            if isFoodType {
                header.configure(with: FoodCategory.allCases[indexPath.section].rawValue)
            } else {
                header.configure(with: NutritionCategory.allCases[indexPath.section].rawValue)
            }
            
            return header
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45) // ✅ 헤더 높이 설정
    }

    
}


    

