// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class AllKeywordsVC: UIViewController {
    public var isFoodType = true
    private let maxSelectionCount = 5
    private var isProcessing = false
        
    // MARK: - UI Components
    private lazy var customBackButton = UIButton().then {
        let image = UIImage(systemName: "lessthan")?.withRenderingMode(.alwaysTemplate)
        $0.setBackgroundImage(image, for: .normal)
        $0.tintColor = UIColor.healeatGray4
        $0.imageView?.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    private lazy var searchBar = CustomCSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.healeatGray5,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        $0.searchBar.attributedPlaceholder = NSAttributedString(string: "음식, 매장, 주소 검색", attributes: attributes)
        $0.searchBar.text = SearchRequestManager.shared.query
        
        $0.returnKeyPressed = { text in
            guard !self.isProcessing else { return }
            self.isProcessing = true
            self.searchButtonClicked()
        }
    }
    private lazy var foodTypeButton = createCategoryButton(title: "음식 종류")
    private lazy var nutritionButton = createCategoryButton(title: "음식 특징")
    
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
        
        hideKeyboardWhenTappedAround()
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func goToFilteredSearch(searchResults: HomeResponse) {
        hideLoadingIndicator()
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.filteredStoresVC.filteredData = searchResults
        filteredSearchVC.filteredStoresVC.storeData = searchResults.storeList
        filteredSearchVC.avgX = searchResults.searchInfo?.avgX
        filteredSearchVC.avgY = searchResults.searchInfo?.avgY
        filteredSearchVC.hidesBottomBarWhenPushed = true // 탭바 숨겨주기
        isProcessing = false
        navigationController?.pushViewController(filteredSearchVC, animated: true)
    }
    
    @objc private func toggleButtonState() {
        foodTypeButton.isSelected.toggle()
        nutritionButton.isSelected.toggle()
        isFoodType.toggle()
        allKeywordsView.collectionview.reloadData()
    }
    
    private func getSearchFilters() -> (query: String, x: String, y: String, foodList: [Int], nutritionList: [Int], searchBy: SearchBy, sortBy: SortBy) {
        return (
            query: searchBar.searchBar.text ?? "",
            x: "\(LocationManager.shared.currentLongitude)",
            y: "\(LocationManager.shared.currentLatitude)",
            foodList: Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0)),
            nutritionList: Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1)),
            searchBy: SortSelectionManager.shared.searchBy,
            sortBy: SortSelectionManager.shared.sortBy
        )
    }
    
    @objc private func searchButtonClicked() {
        showLoadingIndicator()
        let filters = getSearchFilters()
        SearchRequestManager.shared.updateFilters(
            query: filters.query,
            x: filters.x,
            y: filters.y,
            categoryIdList: filters.foodList,
            featureIdList: filters.nutritionList,
            minRating: 0.0,
            searchBy: filters.searchBy,
            sortBy: filters.sortBy
        )
        
        search()
    }

    //MARK: API call
    private func search() {
        let param = SearchRequestManager.shared.currentRequest

        CSearchManager.search(page: 1, param: param) { isSuccess, searchResults in
            guard isSuccess, let searchResults = searchResults else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }
            
            self.goToFilteredSearch(searchResults: searchResults)
        }
    }

}

extension AllKeywordsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = isFoodType ? 0 : 1
        let (id, _) = getCategoryItemInfo(at: indexPath)

        updateSelection(id: id, categoryType: categoryType)
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
    
    private func getCategoryItemInfo(at indexPath: IndexPath) -> (id: Int, name: String) {
        let categoryType = isFoodType ? 0 : 1
        let item: (id: Int, name: String)

        if isFoodType {
            let foodCategory = FoodCategory.allCases[indexPath.section].sections[indexPath.row]
            item = (foodCategory.id, foodCategory.name)
        } else {
            let nutritionCategory = NutritionCategory.allCases[indexPath.section].sections[indexPath.row]
            item = (nutritionCategory.id, nutritionCategory.name)
        }
        return (item.id, item.name)
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

}


extension AllKeywordsVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}

// MARK: - Helpers
extension AllKeywordsVC {
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
}
