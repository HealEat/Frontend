// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class AllKeywordsVC: UIViewController {
    var isFoodType = true
    let maxSelectionCount = 5
        
    
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
        $0.searchBar.text = SearchRequestManager.shared.query
        
        $0.returnKeyPressed = { text in
            self.searchButtonClicked()
        }
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        foodTypeButton.isSelected = isFoodType
        nutritionButton.isSelected = !isFoodType
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
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
    
    private func goToFilteredSearch(searchResults: HomeResponse) {
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.filteredStoresVC.filteredData = searchResults
        filteredSearchVC.filteredStoresVC.storeData = searchResults.storeList
        filteredSearchVC.hidesBottomBarWhenPushed = true // 탭바 숨겨주기
        navigationController?.pushViewController(filteredSearchVC, animated: true)
    }
    
    @objc private func toggleButtonState() {
        foodTypeButton.isSelected.toggle()
        nutritionButton.isSelected.toggle()
        isFoodType.toggle()
        allKeywordsView.collectionview.reloadData()
    }
    
    
    @objc private func searchButtonClicked() {
        let query = searchBar.searchBar.text ?? ""
        let foodList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
        let nutritionList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))
        let x = LocationManager.shared.currentLongitude
        let y = LocationManager.shared.currentLatitude
        let searchBy = SortSelectionManager.shared.searchBy
        let sortBy = SortSelectionManager.shared.sortBy
        
        // ✅ `SearchRequestManager`에 업데이트
        SearchRequestManager.shared.updateFilters(
            query: query,
            x: "\(x)",
            y: "\(y)",
            categoryIdList: foodList,
            featureIdList: nutritionList,
            minRating: 0.0,
            searchBy: searchBy,
            sortBy: sortBy
        )
        
        // ✅ 검색 API 요청
        search()
    }

    
    //MARK: API call
    
    private func search() {
        let param = SearchRequestManager.shared.currentRequest
        print("📡 검색 요청: \(param)")

        CSearchManager.search(page: 1, param: param) { isSuccess, searchResults in
            guard isSuccess, let searchResults = searchResults else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }
            print("✅ 검색 성공! 사용된 필터: \(param)")
            print("🔍 받아온 검색 결과: \(searchResults)")
            
            self.goToFilteredSearch(searchResults: searchResults)
        }
    }

}

extension AllKeywordsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isFoodType ? FoodCategory.allCases.count : NutritionCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFoodType ? FoodCategory.allCases[section].sections.count : NutritionCategory.allCases[section].sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell

        let categoryType = isFoodType ? 0 : 1

        // ✅ ID 및 이름 가져오기
        let id: Int
        let item: String
        if isFoodType {
            let foodCategory = FoodCategory.allCases[indexPath.section].sections[indexPath.row]
            id = foodCategory.id
            item = foodCategory.name
        } else {
            let nutritionCategory = NutritionCategory.allCases[indexPath.section].sections[indexPath.row]
            id = nutritionCategory.id
            item = nutritionCategory.name
        }
        
        // ✅ 셀에 데이터 적용
        cell.label.text = item

        // ✅ 선택된 상태 반영
        let isSelected = CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id)
        cell.updateUI(isSelected: isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = isFoodType ? 0 : 1

        // ✅ ID 가져오기
        let id = isFoodType
        ? FoodCategory.allCases[indexPath.section].sections[indexPath.row].id
        : NutritionCategory.allCases[indexPath.section].sections[indexPath.row].id

        if CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id) {
            // ✅ 선택 해제
            CategorySelectionManager.shared.removeSelection(id, forCategory: categoryType)
        } else {
            // ✅ 현재 선택된 총 개수 확인 (새로운 선택만 제한)
            if CategorySelectionManager.shared.getTotalSelectedCount() >= maxSelectionCount {
                Toaster.shared.makeToast("5개 이상 선택할 수 없습니다.", .short)
                return
            }
            // ✅ 새로운 선택 추가
            CategorySelectionManager.shared.addSelection(id, forCategory: categoryType)
        }

        // ✅ UI 업데이트 → 특정 셀만 다시 로드
        collectionView.reloadItems(at: [indexPath])
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


extension AllKeywordsVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}
