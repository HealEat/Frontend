// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit
import SwiftyToaster

class FilteredStoresVC: UIViewController, ChangeFilterVCDelegate {
    public var filteredData: HomeResponse?
    public var storeData: [StoreResponse] = []
    var filterArr = ["속 편한 음식", "영업중", "죽"]
    public let storeview = FilteredStoresView()
    private var isFetchingData = false
    var currentPage = 2
    var isLastPage = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = storeview
        storeview.isUserInteractionEnabled = true
        setupCollectionView()
        storeview.filterButton.addTarget(self, action: #selector(goToFilterVC), for: .touchUpInside)
        storeview.setByUserInfoButton.addTarget(self, action: #selector(sortByUserInfo(_:)), for: .touchUpInside)
        storeview.setByResultButton.addTarget(self, action: #selector(sortByResult(_:)), for: .touchUpInside)
        
        if storeData.isEmpty {
            //storeview.showEmptyState() // ✅ 예시 함수 (필요하면 추가)
            print("검색 결과 없음..")
        } else {
            DispatchQueue.main.async {
                self.reloadCollectionView()
            }
        }

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
    
    private func fetchStoreData(reset: Bool = false) {
        guard !isLastPage else { return }
        
        if reset {
            storeData.removeAll()
            currentPage = 1
            isLastPage = false
        }
        
        isFetchingData = true // API 호출 시작
        
        if currentPage == 1 {
            let foodList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
            let nutritionList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))
            let searchBy = SortSelectionManager.shared.searchBy
            let sortBy = SortSelectionManager.shared.sortBy
            // ✅ `SearchRequestManager`에 업데이트
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
        
        let searchRequest = SearchRequestManager.shared.currentRequest
        
        
        CSearchManager.search(page: currentPage, param: searchRequest) { isSuccess, result in
            self.isFetchingData = false
            guard isSuccess, let searchResults = result else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }
            let storeList = searchResults.storeList
            if reset {
                self.storeData = storeList
            } else {
                self.storeData.append(contentsOf: storeList)
            }
            if storeList.isEmpty {
                self.isLastPage = true
            }
            self.currentPage += 1
            self.isLastPage = searchResults.isLast ?? false
            
            DispatchQueue.main.async {
                //self.storeview.storeCollectionView.reloadData()
                self.reloadCollectionView()
            }
            NotificationCenter.default.post(
                name: .updateMapsVC,
                object: nil,
                userInfo: [
                    "lat": searchResults.searchInfo?.avgY ?? LocationManager.shared.currentLatitude,
                    "lon": searchResults.searchInfo?.avgX ?? LocationManager.shared.currentLongitude ]
            )
    
        }
        
    }
        


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    public func reloadCollectionView() {
        DispatchQueue.main.async {
            print("reloadCollectionView")
            self.storeview.storeCollectionView.reloadData()
            self.storeview.storeCollectionView.collectionViewLayout.invalidateLayout()
            self.storeview.storeCollectionView.layoutIfNeeded()
            
            // ✅ 특정 필터가 선택된 경우에만 filteredCollectionView 표시
            self.updateFilteredCollectionViewHeight()
        }
    }

    
    
    @objc private func goToFilterVC() {
        let bottomSheet = ChangeFilterVC()
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.45 // ✅ 화면 높이의 30% 크기로 설정
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
            
            // ✅ 버튼의 실제 화면 위치를 가져옴
            if let superview = button.superview {
                let buttonFrameInSuperview = superview.convert(button.frame, to: view)
                
                // ✅ 버튼의 오른쪽 끝 + 5pt만큼 이동
                popover.sourceRect = CGRect(
                    x: buttonFrameInSuperview.width + 60, // 버튼 오른쪽 바깥쪽에 위치
                    y: buttonFrameInSuperview.height / 2, // 버튼 중앙 높이 맞추기
                    width: 0,
                    height: 0
                )
            }
            
            popover.permittedArrowDirections = [] // 화살표 없애기
            popover.delegate = self
            popover.backgroundColor = .white
        }
        
        //sortingVC.preferredContentSize = CGSize(width: 122, height: 158) // ✅ 작은 크기로 표시
        present(sortingVC, animated: true)
    }
    
    
    private func shouldShowFilteredCollectionView() -> Bool {
        let foodList = CategorySelectionManager.shared.getSelectedItems(forCategory: 0)
        let nutritionList = CategorySelectionManager.shared.getSelectedItems(forCategory: 1)
        

        return !foodList.isEmpty || !nutritionList.isEmpty
    }
    
    private func updateFilteredCollectionViewHeight() {
        let shouldShow = shouldShowFilteredCollectionView()
        let targetHeight: CGFloat = shouldShow ? 30 : 0

        // ✅ 높이가 변경될 때만 애니메이션 실행
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
            return filterArr.count
        } else {
            return 0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            if storeData.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmptyStateCell.identifier,
                    for: indexPath
                ) as? EmptyStateCell else {
                    return UICollectionViewCell()
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StoreCollectionViewCell.identifier,
                    for: indexPath
                ) as? StoreCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.storeconfigure(model: storeData[indexPath.row])
                return cell
            }
        } else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallFilterCell.identifier,for: indexPath) as? SmallFilterCell else { return UICollectionViewCell() }
            cell.label.text = filterArr[indexPath.row]
            cell.updateUI(isSelected: true)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            //let item = (collectionView.tag == 0) ? foodTypeList[indexPath.item].name : nutritionList[indexPath.item].name
            let item = filterArr[indexPath.row]
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.text = item
            label.sizeToFit()
            
            return CGSize(width: label.frame.width + 13, height: label.frame.height + 8)
        }
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: UIScreen.main.bounds.width - 32, height: 123)
            
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // 🔥 마지막 페이지이면 요청 중단
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
        fetchStoreData(reset: true)
        isLastPage = false
    }
}

// MARK: - Popover Delegate (화면 터치 시 닫힘)
extension FilteredStoresVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // ✅ iPhone에서도 popover 스타일 유지
    }
}


