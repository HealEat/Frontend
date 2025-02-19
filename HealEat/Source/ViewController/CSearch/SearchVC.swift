// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster
import CoreLocation

class SearchVC: UIViewController {
    let foodTypeList = FoodCategory.allItems
    let nutritionList = NutritionCategory.allItems
    var recentSearches: [RecentSearchItem] = []
    // ✅ 선택된 셀을 저장할 변수 (두 개의 컬렉션뷰를 개별적으로 관리)
    var selectedFoodType: Set<IndexPath> = [] // 첫 번째 컬렉션뷰의 선택된 항목
    var selectedNutritionType: Set<IndexPath> = [] // 두 번째 컬렉션뷰의 선택된 항목
    // ✅ 최대 선택 가능 개수
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
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell") // ✅ 기본 셀 등록
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
        

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // ✅ 위치 권한 요청 (앱 실행 시 한 번만 요청됨)
        LocationManager.shared.requestAuthorization()
        // ✅ 위치 업데이트 시작
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
    
    private func updateFilterCollectionView() {
        let hasSelectedItems = !CategorySelectionManager.shared.getSelectedItems(forCategory: 0).isEmpty ||
                               !CategorySelectionManager.shared.getSelectedItems(forCategory: 1).isEmpty

        let targetHeight: CGFloat = hasSelectedItems ? 37 : 0
        let shouldAnimate = self.selectedKeywordCollectionView.frame.height != targetHeight

        if shouldAnimate {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.selectedKeywordCollectionView.alpha = hasSelectedItems ? 1 : 0 // ✅ 페이드 인/아웃 추가
                self.selectedKeywordCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(targetHeight) // ✅ 높이 조정
                }
                self.view.layoutIfNeeded()
            }) { _ in
                if hasSelectedItems {
                    self.selectedKeywordCollectionView.reloadData() // ✅ 애니메이션 완료 후 reloadData 호출
                }
            }
        } else if hasSelectedItems {
            self.selectedKeywordCollectionView.reloadData() // ✅ 높이 변화가 없을 때만 reloadData 호출
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
    
    
    private func goToFilteredSearch(searchResults: HomeResponse) {
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.filteredStoresVC.filteredData = searchResults
        filteredSearchVC.filteredStoresVC.storeData = searchResults.storeList
        filteredSearchVC.avgX = searchResults.searchInfo?.avgX
        filteredSearchVC.avgY = searchResults.searchInfo?.avgY
        filteredSearchVC.hidesBottomBarWhenPushed = true // 탭바 숨겨주기
        navigationController?.pushViewController(filteredSearchVC, animated: true)
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
        let recentId = sender.tag // ✅ 버튼 태그에서 ID 가져오기
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
            return CategorySelectionManager.shared.getSelectedItems(forCategory: 0).count +
                   CategorySelectionManager.shared.getSelectedItems(forCategory: 1).count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryType = collectionView.tag

        switch categoryType {
        case 0, 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell
            let item = (categoryType == 0) ? foodTypeList[indexPath.row].name : nutritionList[indexPath.row].name
            let id = (categoryType == 0) ? foodTypeList[indexPath.row].id : nutritionList[indexPath.row].id

            // ✅ 셀에 데이터 적용
            cell.label.text = item

            // ✅ 선택된 상태 반영
            let isSelected = CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id)
            cell.updateUI(isSelected: isSelected)
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredKeywordCell.identifier, for: indexPath) as! FilteredKeywordCell

            // ✅ 선택된 값 가져오기 (foodType 먼저, nutritionType 나중)
            let foodSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
            let nutritionSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))

            let totalFoodCount = foodSelected.count
            let id: Int
            let name: String
            let isFoodType: Bool

            if indexPath.row < totalFoodCount {
                // ✅ foodType에서 선택된 값
                id = foodSelected[indexPath.row]
                name = foodTypeList.first { $0.id == id }?.name ?? ""
                isFoodType = true
            } else {
                // ✅ nutritionType에서 선택된 값
                let nutritionIndex = indexPath.row - totalFoodCount
                id = nutritionSelected[nutritionIndex]
                name = nutritionList.first { $0.id == id }?.name ?? ""
                isFoodType = false
            }

            cell.configure(with: name, id: id, categoryType: isFoodType ? 0 : 1, target: self, action: #selector(selectedItemButtonTapped(_:)))

            return cell

        default:
            return UICollectionViewCell()
        }
    }
    
    @objc private func selectedItemButtonTapped(_ sender: UIButton) {
        guard let categoryTypeString = sender.accessibilityHint,
              let categoryType = Int(categoryTypeString) else { return }

        let id = sender.tag

        // ✅ 정확한 카테고리에서 ID 삭제
        CategorySelectionManager.shared.removeSelection(id, forCategory: categoryType)

        // ✅ 전체 reloadData()로 간단하게 처리
        updateFilterCollectionView()

        // ✅ 삭제된 항목에 따라 다른 CollectionView도 업데이트
        if categoryType == 0 {
            foodTypeCollectionView.reloadData()
        } else if categoryType == 1 {
            nutritionCollectionView.reloadData()
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = collectionView.tag

        switch categoryType {
        case 0, 1:
            // ✅ ID 가져오기
            let id = (categoryType == 0) ? foodTypeList[indexPath.row].id : nutritionList[indexPath.row].id

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
            updateFilterCollectionView()

        case 2:
            break

        default:
            break
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item: String

        if collectionView.tag == 2 {
            // ✅ Tag == 2 → 선택된 값 기준
            let foodSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
            let nutritionSelected = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))

            let totalFoodCount = foodSelected.count
            let totalNutritionCount = nutritionSelected.count

            let id: Int

            if indexPath.row < totalFoodCount {
                // ✅ foodType에서 선택된 값
                id = foodSelected[indexPath.row]
                item = foodTypeList.first { $0.id == id }?.name ?? ""
            } else {
                // ✅ nutritionType에서 선택된 값
                let nutritionIndex = indexPath.row - totalFoodCount
                id = nutritionSelected[nutritionIndex]
                item = nutritionList.first { $0.id == id }?.name ?? ""
            }

            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.text = item
            label.sizeToFit()

            return CGSize(width: label.frame.width + 26, height: label.frame.height + 7)
        } else if collectionView.tag == 0 {
            item = foodTypeList[indexPath.item].name
        } else {
            item = nutritionList[indexPath.item].name
        }

        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = item
        label.sizeToFit()

        return CGSize(width: label.frame.width + 13, height: label.frame.height + 7)
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
    
    
}


