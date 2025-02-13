// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

class FilteredStoresVC: UIViewController {
    public var filteredData: HomeResponse?
    public var storeData: [StoreResponse] = []
    public let storeview = FilteredStoresView()
    private var isFetchingData = false
    var currentPage = 1
    var isLastPage = false
    private var currentLatitude: Double = 37.550874837441
    private var currentLongitude: Double = 126.925554591431
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = storeview
        storeview.isUserInteractionEnabled = true
        setupCollectionView()
        storeview.filterButton.addTarget(self, action: #selector(goToFilterVC), for: .touchUpInside)
        
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
        fetchStoreData(reset: true)
    }
    
    private func fetchStoreData(reset: Bool = false) {
        guard !isLastPage else { return }
        
        if reset {
            storeData.removeAll()
            currentPage = 1
            isLastPage = false
        }

        isFetchingData = true // API 호출 시작
        
        // 현재 위치를 사용하여 API 요청을 보냄 -> MARK: search로 수정 필요
        APIManager.HomeProvider.request(.getStores(lon: currentLongitude, lat: currentLatitude, radius: 1000, page: currentPage)) { result in
            self.isFetchingData = false

            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(DefaultResponse<HomeResponse>.self, from: response.data)
                    
                    let memberName = decodedData.result?.searchInfo?.memberName ?? "힐릿"
                        DispatchQueue.main.async {
                            //self.storeview.setUserRecommendLabel(name: memberName)
                    }
                    
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
                return context.maximumDetentValue * 0.55 // ✅ 화면 높이의 30% 크기로 설정
            })]
            sheet.prefersGrabberVisible = false
        }
        present(bottomSheet, animated: true)
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


