// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

class FilteredStoresVC: UIViewController {
    public var searchRequest: CSearchRequest?
    public var filteredData: HomeResponse?
    public var storeData: [StoreResponse] = []
    public let storeview = FilteredStoresView()
    private var isFetchingData = false
    var currentPage = 2
    var isLastPage = false
    private var currentLatitude: Double = 37.550874837441
    private var currentLongitude: Double = 126.925554591431
    

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
    

    
    func updateLocation(lat: Double, lon: Double) {
        self.currentLatitude = lat
        self.currentLongitude = lon
        //MARK: 주의!! 너무 자주 호출되지 않나 확인
        fetchStoreData(reset: true)
    }
    
    private func fetchStoreData(reset: Bool = false) {
        guard !isLastPage else { return }
        guard let searchRequest = searchRequest else { return }
        
        if reset {
            storeData.removeAll()
            currentPage = 1
            isLastPage = false
        }

        isFetchingData = true // API 호출 시작
        
        APIManager.CSearchProvider.request(.search(page: currentPage, param: searchRequest)) { result in
            self.isFetchingData = false

            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(DefaultResponse<HomeResponse>.self, from: response.data)
                    if let storeList = decodedData.result?.storeList {
                        if reset {
                            self.storeData = storeList
                        } else {
                            self.storeData.append(contentsOf: storeList)
                        }
                        self.currentPage += 1
                        self.isLastPage = decodedData.result?.isLast ?? false

                        DispatchQueue.main.async {
                            self.storeview.storeCollectionView.reloadData()
                        }
                    }
                } catch {
                    print("❌ JSON 디코딩 오류:", error)
                }
            case .failure(let error):
                print("❌ API 요청 실패:", error)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupCollectionView() {
        storeview.storeCollectionView.dataSource = self
        storeview.storeCollectionView.delegate = self
        storeview.storeCollectionView.bounces = false
        storeview.storeCollectionView.contentInsetAdjustmentBehavior = .never
        storeview.storeCollectionView.isScrollEnabled = true
        storeview.storeCollectionView.canCancelContentTouches = false
        storeview.storeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
    }
    
    public func reloadCollectionView() {
        DispatchQueue.main.async {
            self.storeview.storeCollectionView.reloadData()
            self.storeview.storeCollectionView.collectionViewLayout.invalidateLayout()
            self.storeview.storeCollectionView.layoutIfNeeded()
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

    


    
}

extension FilteredStoresVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: StoreCollectionViewCell.identifier, for: indexPath) as? StoreCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let model = storeData[indexPath.row]
        cell.storeconfigure(model: model)

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2, !isFetchingData {
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
    }
}

// MARK: - Popover Delegate (화면 터치 시 닫힘)
extension FilteredStoresVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // ✅ iPhone에서도 popover 스타일 유지
    }
}
