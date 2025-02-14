// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class FilteredSearchVC: UIViewController, MapsVCDelegate {
    // MARK: - UI Properties
    private var mapsVC: MapsVC?
    private let filteredStoreView = FilteredStoresView()
    private var modalHeightConstraint: NSLayoutConstraint!
    private var storePanGesture: UIPanGestureRecognizer?
    public var filteredStoresVC = FilteredStoresVC() // StoreVC 추가
    public var avgX: Double?
    public var avgY: Double?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapsVC()
        setupStoresVC()
        setupSearchBar()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.filteredStoresVC.reloadCollectionView() // StoreVC에서 컬렉션 뷰 강제 리로드
        }
    }
    
    private func setupSearchBar() {
        let searchBar = MapSearchBar().then {
            $0.dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            let placeholder = NSAttributedString(string: "검색", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.healeatGray5
            ])
            $0.searchBar.attributedPlaceholder = placeholder
            $0.searchBar.text = SearchRequestManager.shared.query
            
            $0.returnKeyPressed = { text in
                SearchRequestManager.shared.updateFilters(query: text)
                self.search()
            }
        }
        
        view.addSubview(searchBar)
        view.bringSubviewToFront(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(45)
        }
    }

    
    private func setupMapsVC() {
        let mapsVC = MapsVC()
        self.mapsVC = mapsVC
        mapsVC.delegate = self
        addChild(mapsVC)
        view.addSubview(mapsVC.view)
        mapsVC.view.frame = view.bounds
        mapsVC.didMove(toParent: self)
        /*LocationManager.shared.onLocationUpdate = { [weak self] lat, lon in
            self?.filteredStoresVC.updateLocation(lat: lat, lon: lon)
        }*/
    }
    
    
    private func setupStoresVC() {
        filteredStoreView.backgroundColor = .white
        filteredStoreView.layer.cornerRadius = 16
        filteredStoreView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filteredStoreView.clipsToBounds = true
            
        view.addSubview(filteredStoreView)
            
        filteredStoreView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(370)
        }
        
        _ = UIScreen.main.bounds.height - 130
        modalHeightConstraint = filteredStoreView.heightAnchor.constraint(equalToConstant: 370)
        modalHeightConstraint.isActive = true
            
        DispatchQueue.main.async {
            self.addGrabber()
        }
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        storePanGesture = panGesture
        storePanGesture?.delegate = self
        filteredStoreView.addGestureRecognizer(panGesture)

        //StoreVC 추가
        addChild(filteredStoresVC)
        filteredStoreView.addSubview(filteredStoresVC.view)
        filteredStoresVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        filteredStoresVC.didMove(toParent: self)
        
        filteredStoresVC.storeview.storeCollectionView.isScrollEnabled = true
        
    }
    
    private func addGrabber() {
        let grabber = UIView()
        grabber.backgroundColor = .lightGray
        grabber.layer.cornerRadius = 3

        filteredStoreView.addSubview(grabber)

        grabber.snp.makeConstraints {
            $0.top.equalTo(filteredStoreView.snp.top).offset(8)
            $0.centerX.equalTo(filteredStoreView.snp.centerX)
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
    }
    
    // ✅ MapsVC가 완전히 로딩된 후 실행됨
    func mapsVCDidFinishLoading(_ mapsVC: MapsVC) {
        mapsVC.updateMapPosition(lat: avgY ?? LocationManager.shared.currentLatitude,
                                    lon: avgX ?? LocationManager.shared.currentLongitude)
    }
    
        
    
    //MARK: - Setup Actions
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let screenHeight = UIScreen.main.bounds.height - 130
        let collectionView = filteredStoresVC.storeview.storeCollectionView

        
        switch gesture.state {
        case .changed:
            let newHeight = min(screenHeight, max(80, modalHeightConstraint.constant - translation.y))
            modalHeightConstraint.constant = newHeight
            gesture.setTranslation(.zero, in: view)
        case .ended:
            let midPoint = UIScreen.main.bounds.height * 0.5 // 중간 높이 계산
            let finalHeight: CGFloat

            if velocity.y > 500 {
                finalHeight = 125 // 아래로 빠르게 스크롤하면 최소 크기로 (탭바 위)
            } else if velocity.y < -500 {
                finalHeight = screenHeight // 위로 빠르게 스크롤하면 최대 크기로 (검색바 아래)
            } else {
                finalHeight = modalHeightConstraint.constant > midPoint ? screenHeight : 370
            }

            UIView.animate(withDuration: 0.3) {
                self.modalHeightConstraint.constant = finalHeight
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
 

    
    //MARK: - API call
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
            self.filteredStoresVC.filteredData = searchResults
            self.filteredStoresVC.storeData = searchResults.storeList
            self.filteredStoresVC.reloadCollectionView()
        }
        
    }

  

}


extension FilteredSearchVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let collectionView = otherGestureRecognizer.view as? UICollectionView {
            return collectionView.contentOffset.y <= 0
        }
        return false
    }
}


