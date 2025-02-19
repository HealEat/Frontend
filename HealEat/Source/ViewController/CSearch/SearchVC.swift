// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster
import CoreLocation

class SearchVC: UIViewController {
    let foodTypeList = FoodCategory.allItems
    let nutritionList = NutritionCategory.allItems
    var recentSearches: [RecentSearchItem] = []
    //  선택된 셀을 저장
    var selectedFoodType: Set<IndexPath> = []
    var selectedNutritionType: Set<IndexPath> = []
    //  최대 선택 가능 개수
    let maxSelectionCount = 5
        
    
    // MARK: - UI Components
    private lazy var searchBar = CustomCSearchBar().then {
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
    
    private lazy var keywordBackground = KeywordChipsView().then {
        $0.backgroundColor = .white
        $0.allKeywordButton.addTarget(self, action: #selector(showKeywords), for: .touchUpInside)
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
        $0.dataSource = self
        $0.delegate = self
        $0.tag = 0
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
        $0.dataSource = self
        $0.delegate = self
        $0.tag = 1
    }
    private lazy var foodTypeButton =  UIButton().then {
        $0.setTitle("+\(foodTypeList.count)", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(showKeywords), for: .touchUpInside)
    }
    private lazy var nutritionButton =  UIButton().then {
        $0.setTitle("+\(nutritionList.count)", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(showNutritionKeywords), for: .touchUpInside)
    }
    
    private lazy var selectedKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 6
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FilteredKeywordCell.self, forCellWithReuseIdentifier: FilteredKeywordCell.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.tag = 2
    }
    
    
    private lazy var tableview = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .white
        $0.separatorColor = UIColor(hex: "EBEBEB")
        $0.separatorInset = .zero
        $0.separatorStyle = .singleLine
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
        

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //  위치 권한 요청 (앱 실행 시 한 번만 요청됨)
        LocationManager.shared.requestAuthorization()
        //  위치 업데이트 시작
        LocationManager.shared.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecentSearches()
        foodTypeCollectionView.reloadData()
        nutritionCollectionView.reloadData()
        updateFilterCollectionView()
    }
    


    // MARK: - UI Methods
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(keywordBackground)
        keywordBackground.addSubview(foodTypeCollectionView)
        keywordBackground.addSubview(nutritionCollectionView)
        keywordBackground.addSubview(foodTypeButton)
        keywordBackground.addSubview(nutritionButton)
        view.addSubview(selectedKeywordCollectionView)
        view.addSubview(tableview)
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(50)
        }
        selectedKeywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(0)
        }
        keywordBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(selectedKeywordCollectionView.snp.bottom).offset(5)
            make.height.equalTo(150)
        }
        foodTypeCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        nutritionCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-60)
            make.centerY.equalTo(foodTypeCollectionView.snp.bottom).offset(30)
            make.height.equalTo(24)
        }
        foodTypeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(37)
            make.height.equalTo(24)
            make.centerY.equalTo(foodTypeCollectionView.snp.centerY)
        }
        nutritionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(37)
            make.height.equalTo(24)
            make.centerY.equalTo(nutritionCollectionView.snp.centerY)
        }
        tableview.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(keywordBackground.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }

    
    //MARK: Setup Actions
    @objc private func showKeywords() {
        let keywordVC = AllKeywordsVC()
        navigationController?.pushViewController(keywordVC, animated: true)
    }
    
    @objc private func showNutritionKeywords() {
        let keywordVC = AllKeywordsVC()
        keywordVC.isFoodType = false
        navigationController?.pushViewController(keywordVC, animated: true)
    }
    
    @objc private func searchButtonClicked() {
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

    // 검색 필터 값 가져오기
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
    
    
    private func goToFilteredSearch(searchResults: HomeResponse) {
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.filteredStoresVC.filteredData = searchResults
        filteredSearchVC.filteredStoresVC.storeData = searchResults.storeList
        filteredSearchVC.avgX = searchResults.searchInfo?.avgX
        filteredSearchVC.avgY = searchResults.searchInfo?.avgY
        filteredSearchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filteredSearchVC, animated: true)
    }

    
    private func updateFilterCollectionView() {
        let hasSelectedItems = isCategorySelected()
        let targetHeight: CGFloat = hasSelectedItems ? 37 : 0
        let shouldAnimate = selectedKeywordCollectionView.frame.height != targetHeight

        if shouldAnimate {
            animateCollectionView(height: targetHeight, show: hasSelectedItems)
        } else if hasSelectedItems {
            selectedKeywordCollectionView.reloadData()
        }
    }

    private func isCategorySelected() -> Bool {
        return !CategorySelectionManager.shared.getSelectedItems(forCategory: 0).isEmpty ||
               !CategorySelectionManager.shared.getSelectedItems(forCategory: 1).isEmpty
    }
    
    private func getTotalSelectedItemsCount() -> Int {
        return CategorySelectionManager.shared.getSelectedItems(forCategory: 0).count +
            CategorySelectionManager.shared.getSelectedItems(forCategory: 1).count
    }

    private func animateCollectionView(height: CGFloat, show: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.selectedKeywordCollectionView.alpha = show ? 1 : 0
            self.selectedKeywordCollectionView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            if show {
                self.selectedKeywordCollectionView.reloadData()
            }
        }
    }


    
    
    //MARK: API call
    private func getRecentSearches() {
        CSearchManager.recentSearches { result in
            switch result {
            case .success(let data):
                guard let searchData = data.result?.recentSearchList else { return }
                self.recentSearches = searchData
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            case .failure(let error):
                print("최근 검색 기록 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    
    @objc private func deleteRecentSearch(_ sender: UIButton) {
        let recentId = sender.tag //  버튼 태그에서 ID 가져오기
        CSearchManager.deleteRecentSearch(recentId: recentId) { isSuccess, response in
            if isSuccess {
                self.getRecentSearches()
                print("최근 검색 기록 삭제 성공")
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("최근 검색 기록 삭제 서버 에러 메시지: \(errorMessage)")
                }
            }
        }
    }
    
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


//MARK: CollectionView
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return foodTypeList.count
        case 1:
            return nutritionList.count
        case 2:
            return getTotalSelectedItemsCount()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryType = collectionView.tag

        switch categoryType {
        case 0, 1:
            return configureKeywordCell(for: collectionView, at: indexPath)
        case 2:
            return configureFilteredKeywordCell(for: collectionView, at: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = collectionView.tag

        switch categoryType {
        case 0, 1:
            handleKeywordSelection(at: indexPath, for: categoryType)
        case 2:
            break
        default:
            break
        }
    }
    
    // filter collectionview 속 버튼 눌림
    @objc private func selectedItemButtonTapped(_ sender: UIButton) {
        guard let categoryTypeString = sender.accessibilityHint,
              let categoryType = Int(categoryTypeString) else { return }
        CategorySelectionManager.shared.removeSelection(sender.tag, forCategory: categoryType)
        
        updateFilterCollectionView()
        
        if categoryType == 0 {
            foodTypeCollectionView.reloadData()
        } else if categoryType == 1 {
            nutritionCollectionView.reloadData()
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemText = getItemText(for: collectionView.tag, at: indexPath)
        return calculateItemSize(for: itemText, isFiltered: collectionView.tag == 2)
    }
    
    //MARK: - helper methods
    private func configureKeywordCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell
        let categoryType = collectionView.tag
        let item = (categoryType == 0) ?
        foodTypeList[indexPath.row] : nutritionList[indexPath.row]
        cell.label.text = item.name
        let isSelected = CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(item.id)
        cell.updateUI(isSelected: isSelected)
        return cell
    }
    private func configureFilteredKeywordCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredKeywordCell.identifier, for: indexPath) as! FilteredKeywordCell
        let (id, name, categoryType) = getSelectedItemInfo(at: indexPath)

        cell.configure(with: name, id: id, categoryType: categoryType, target: self, action: #selector(selectedItemButtonTapped(_:)))
        return cell
    }
    
    
    private func getSelectedItemInfo(at indexPath: IndexPath) -> (id: Int, name: String, categoryType: Int) {
        let foodSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
        let nutritionSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))
        let totalFoodCount = foodSelected.count

        if indexPath.row < totalFoodCount {
            let id = foodSelected[indexPath.row]
            let name = foodTypeList.first { $0.id == id }?.name ?? ""
            return (id, name, 0)
        } else {
            let id = nutritionSelected[indexPath.row - totalFoodCount]
            let name = nutritionList.first { $0.id == id }?.name ?? ""
            return (id, name, 1)
        }
    }
    
    private func handleKeywordSelection(at indexPath: IndexPath, for categoryType: Int) {
        let id = (categoryType == 0) ? foodTypeList[indexPath.row].id : nutritionList[indexPath.row].id

        if CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id) {
            CategorySelectionManager.shared.removeSelection(id, forCategory: categoryType)
        } else {
            if CategorySelectionManager.shared.getTotalSelectedCount() >= maxSelectionCount {
                Toaster.shared.makeToast("5개 이상 선택할 수 없습니다.", .short)
                return
            }
            CategorySelectionManager.shared.addSelection(id, forCategory: categoryType)
        }
        let targetCollectionView: UICollectionView = (categoryType == 0)
        ? foodTypeCollectionView : nutritionCollectionView
        targetCollectionView.reloadItems(at: [indexPath])
        
        updateFilterCollectionView()
    }
    
    
    private func getItemText(for categoryType: Int, at indexPath: IndexPath) -> String {
        if categoryType == 2 {
            let (id, name, _) = getSelectedItemInfo(at: indexPath)
            return name
        } else {
            return categoryType == 0 ? foodTypeList[indexPath.row].name : nutritionList[indexPath.row].name
        }
    }
    private func calculateItemSize(for text: String, isFiltered: Bool) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = text
        label.sizeToFit()

        let widthPadding: CGFloat = isFiltered ? 26 : 13
        return CGSize(width: label.frame.width + widthPadding, height: label.frame.height + 7)
    }

}



//MARK: TableView
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            cell.textLabel?.text = "최근 검색"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            cell.textLabel?.textColor = UIColor.healeatGray5
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else { return UITableViewCell() }

            let searchData = recentSearches[indexPath.row - 1]
            cell.configure(with: searchData, target: self, action: #selector(deleteRecentSearch(_:)))

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        } else {
            return 35
        }
    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true) // 스크롤 시작하면 키보드 내리기
    }
    
    
}

