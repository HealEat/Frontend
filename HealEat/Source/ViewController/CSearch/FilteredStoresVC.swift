// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit
import SwiftyToaster

class FilteredStoresVC: UIViewController, ChangeFilterVCDelegate {
    public var filteredData: HomeResponse?
    public var storeData: [StoreResponse] = []
    private var isFetchingData = false
    var currentPage = 2
    var isLastPage = false
    
    var filterArr: [String] = []
    var finalArr: [String] = []
    
    public let storeview = FilteredStoresView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view = storeview
        storeview.isUserInteractionEnabled = true
        setupCollectionView()
        setupButtons()
        
        if !storeData.isEmpty {
            reloadCollectionView()
        }
    }
    
    private func setupButtons() {
        storeview.filterButton.addTarget(self, action: #selector(goToFilterVC), for: .touchUpInside)
        storeview.setByUserInfoButton.addTarget(self, action: #selector(sortByUserInfo(_:)), for: .touchUpInside)
        storeview.setByResultButton.addTarget(self, action: #selector(sortByResult(_:)), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        storeview.storeCollectionView.dataSource = self
        storeview.storeCollectionView.delegate = self
        storeview.filterCollectionView.dataSource = self
        storeview.filterCollectionView.delegate = self
        storeview.storeCollectionView.bounces = false
        storeview.storeCollectionView.contentInsetAdjustmentBehavior = .never
        storeview.storeCollectionView.isScrollEnabled = true
        storeview.storeCollectionView.canCancelContentTouches = false
        storeview.storeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
    }
    
    func didReceiveSearchResults(_ results: HomeResponse) {
        self.filteredData = results
        self.storeData = results.storeList
        self.reloadCollectionView()
        
        NotificationCenter.default.post(
            name: .updateMapsVC,
            object: nil,
            userInfo:
                ["lat": results.searchInfo?.avgY ?? LocationManager.shared.currentLatitude,
                 "lon": results.searchInfo?.avgX ?? LocationManager.shared.currentLongitude]
        )

    }
    
    // MARK: - API Calls
    private func fetchStoreData(reset: Bool = false) {
        guard !isLastPage else { return }
        
        if reset {
            storeData.removeAll()
            currentPage = 1
            isLastPage = false
        }
        
        if currentPage == 1 {
            updateSearchRequest()
        }
        
        isFetchingData = true // API 호출 시작
        let searchRequest = SearchRequestManager.shared.currentRequest
        
        CSearchManager.search(page: currentPage, param: searchRequest) { [weak self] isSuccess, result in
            guard let self = self else { return }
            self.isFetchingData = false
            guard isSuccess, let searchResults = result else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }

            self.updateStoreData(with: searchResults, reset: reset)
            self.notifyMapUpdate(with: searchResults)
    
        }
        
    }
    
    
    private func updateSearchRequest() {
        let foodList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
        let nutritionList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))
        let searchBy = SortSelectionManager.shared.searchBy
        let sortBy = SortSelectionManager.shared.sortBy
            
        SearchRequestManager.shared.updateFilters(
            x: "\(LocationManager.shared.currentLongitude)",
            y: "\(LocationManager.shared.currentLatitude)",
            categoryIdList: foodList,
            featureIdList: nutritionList,
            minRating: 0.0,
            searchBy: searchBy,
            sortBy: sortBy
        )
    }
    
    private func updateStoreData(with searchResults: HomeResponse, reset: Bool) {
        if searchResults.storeList.isEmpty {
            isLastPage = true
        }
        if reset {
            storeData = searchResults.storeList
        } else {
            storeData.append(contentsOf: searchResults.storeList)
        }
        isLastPage = searchResults.isLast
        currentPage += 1
        DispatchQueue.main.async { self.reloadCollectionView() }
        hideLoadingIndicator()
    }
    
    private func notifyMapUpdate(with searchResults: HomeResponse) {
        NotificationCenter.default.post(
            name: .updateMapsVC,
            object: nil,
            userInfo: [
                "lat": searchResults.searchInfo?.avgY ?? LocationManager.shared.currentLatitude,
                "lon": searchResults.searchInfo?.avgX ?? LocationManager.shared.currentLongitude
            ]
        )
    }
        
    // MARK: - UI Updates
    public func reloadCollectionView() {
        DispatchQueue.main.async {
            self.storeview.storeCollectionView.reloadData()
            self.storeview.storeCollectionView.collectionViewLayout.invalidateLayout()
            self.storeview.storeCollectionView.layoutIfNeeded()
            
            // 특정 필터가 선택된 경우에만 filteredCollectionView 표시
            self.updateFilteredCollectionViewHeight()
        }
    }
    
    private func makeFilterArray() {
        let foodIds = CategorySelectionManager.shared.getSelectedItems(forCategory: 0)
        let selectedFood = FoodCategory.allItems.filter { foodIds.contains($0.id) }.map { $0.name }
        let nutritionIds = CategorySelectionManager.shared.getSelectedItems(forCategory: 1)
        let selectedNutrition = NutritionCategory.allItems.filter { nutritionIds.contains($0.id) }.map { $0.name }
        
        filterArr = selectedFood + selectedNutrition
        
        finalArr = filterArr
        let minRating = SearchRequestManager.shared.minRating
        if minRating >= 3.5 {
            finalArr.append("별점 \(SearchRequestManager.shared.minRating)이상")
        }
        
        // filterArr에 없는 값을 FoodCategory나 NutritionCategory에서 랜덤하게 추가
        let allItems = FoodCategory.allItems.map { $0.name } + NutritionCategory.allItems.map { $0.name }
        let availableItems = allItems.filter { !filterArr.contains($0) } // filterArr에 없는 값들
        
        if let randomItem = availableItems.randomElement() { // 랜덤으로 하나 선택
            finalArr.append(randomItem)
        }
        DispatchQueue.main.async {
            self.storeview.filterCollectionView.reloadData()
            self.storeview.storeCollectionView.collectionViewLayout.invalidateLayout()
            self.storeview.storeCollectionView.layoutIfNeeded()
        }
        
    }

    
    
    @objc private func goToFilterVC() {
        let bottomSheet = ChangeFilterVC()
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.45
            })]
            sheet.prefersGrabberVisible = false
        }
        bottomSheet.delegate = self
        present(bottomSheet, animated: true)
    }
    
    @objc private func sortByUserInfo(_ sender: UIButton) {
        let arr = SortBy.allItems
        showSortingDropdown(filters: arr, sender: sender, isSortBy: true)
    }
    @objc private func sortByResult(_ sender: UIButton) {
        let arr = SearchBy.allItems
        showSortingDropdown(filters: arr, sender: sender, isSortBy: false)
    }
    
    
    private func showSortingDropdown(filters: [String], sender: UIButton, isSortBy: Bool) {
        let sortingVC = SortingDropdownVC()
        sortingVC.delegate = self
        sortingVC.sortingOptions = filters
        sortingVC.isSortBy = isSortBy
        if isSortBy {
            sortingVC.selectedOption = SortSelectionManager.shared.sortBy.name
        } else {
            sortingVC.selectedOption = SortSelectionManager.shared.searchBy.name
        }
        sortingVC.modalPresentationStyle = .popover
        sortingVC.modalTransitionStyle = .crossDissolve
        
        if let popover = sortingVC.popoverPresentationController {
            let button = sender
            popover.sourceView = button
            
            // 버튼의 실제 화면 위치를 가져와서 그에 맞게 vc 띄우기
            if let superview = button.superview {
                let buttonFrameInSuperview = superview.convert(button.frame, to: view)
                popover.sourceRect = CGRect(
                    x: buttonFrameInSuperview.width + 60,
                    y: buttonFrameInSuperview.height / 2,
                    width: 0,
                    height: 0
                )
            }
            popover.permittedArrowDirections = []
            popover.delegate = self
            popover.backgroundColor = .white
        }
        present(sortingVC, animated: true)
    }
    
    
    private func shouldShowFilteredCollectionView() -> Bool {
        let foodList = CategorySelectionManager.shared.getSelectedItems(forCategory: 0)
        let nutritionList = CategorySelectionManager.shared.getSelectedItems(forCategory: 1)
        return !foodList.isEmpty || !nutritionList.isEmpty
    }
    
    private func updateFilteredCollectionViewHeight() {
        makeFilterArray()
        let shouldShow = shouldShowFilteredCollectionView()
        let targetHeight: CGFloat = shouldShow ? 30 : 0

        //  높이가 변경될 때만 애니메이션 실행
        guard storeview.filterCollectionView.frame.height != targetHeight else {
            if shouldShow { storeview.filterCollectionView.reloadData() }
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.storeview.filterCollectionView.alpha = shouldShow ? 1 : 0
            self.storeview.filterCollectionView.snp.updateConstraints {
                $0.height.equalTo(targetHeight)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            if shouldShow {
                self.storeview.filterCollectionView.reloadData()
            }
        }
    }






}

extension FilteredStoresVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return storeData.isEmpty ? 1 : storeData.count
        } else if collectionView.tag == 1 {
            return finalArr.count
        } else {
            return 0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            if storeData.isEmpty {
                return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.identifier, for: indexPath) as? EmptyStateCell ?? UICollectionViewCell()
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.identifier, for: indexPath) as? StoreCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.storeconfigure(model: storeData[indexPath.row])
                    return cell
                }
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallFilterCell.identifier, for: indexPath) as? SmallFilterCell else { return UICollectionViewCell() }
                let item = finalArr[indexPath.row]
                let state: SmallFilterCellState = filterArr.contains(item) ? .filter : item.contains("별점") ? .rating : .recommended
                cell.updateUI(state: state)
                cell.label.text = item
                return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let item = finalArr[indexPath.row]
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.text = item
            label.sizeToFit()
            
            return CGSize(width: label.frame.width + 12, height: label.frame.height + 7)
        }
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: UIScreen.main.bounds.width - 32, height: 123)
            
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        //  마지막 페이지이면 요청 중단
        guard !isFetchingData, !isLastPage else { return }

        if offsetY > contentHeight - height * 2 {
            isFetchingData = true
            fetchStoreData()
        }
    }
}



// MARK: - Sorting Delegate
extension FilteredStoresVC: SortingDropdownDelegate {
    func didSelectSortingOption(_ option: String, isSortBy: Bool) {
        if isSortBy {
            storeview.setByUserInfoButton.buttonLabel.text = option
        } else {
            storeview.setByResultButton.buttonLabel.text = option
        }
        showLoadingIndicator()
        fetchStoreData(reset: true)
        isLastPage = false
    }
}

// MARK: - Popover Delegate
extension FilteredStoresVC: UIPopoverPresentationControllerDelegate {
    
    //sortingVC의 popover style 유지
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


