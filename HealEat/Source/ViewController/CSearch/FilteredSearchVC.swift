// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class FilteredSearchVC: UIViewController {
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
        
        setupViews()
        setupGestures()
        setupNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.filteredStoresVC.reloadCollectionView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        setupMapsVC()
        setupStoresVC()
        setupSearchBar()
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
        addChild(mapsVC)
        view.addSubview(mapsVC.view)
        mapsVC.view.frame = view.bounds
        mapsVC.didMove(toParent: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(mapsVCDidLoad), name: .mapsVCDidLoad, object: nil)
    }
    
    private func setupStoresVC() {
        filteredStoreView.configureForModal()
        view.addSubview(filteredStoreView)
            
        filteredStoreView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(370)
        }
        
        modalHeightConstraint = filteredStoreView.heightAnchor.constraint(equalToConstant: 370)
        modalHeightConstraint.isActive = true
            
        DispatchQueue.main.async {
            self.addGrabber()
        }

        //StoreVC 추가
        addChild(filteredStoresVC)
        filteredStoreView.addSubview(filteredStoresVC.view)
        filteredStoresVC.didMove(toParent: self)
        filteredStoresVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filteredStoresVC.storeview.storeCollectionView.isScrollEnabled = true
    }
    
    private func addGrabber() {
        let grabber = UIView().then {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 3
        }
        
        filteredStoreView.addSubview(grabber)
        grabber.snp.makeConstraints {
            $0.top.equalTo(filteredStoreView.snp.top).offset(8)
            $0.centerX.equalTo(filteredStoreView.snp.centerX)
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        storePanGesture = panGesture
        storePanGesture?.delegate = self
        filteredStoreView.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(mapsVCDidLoad), name: .mapsVCDidLoad, object: nil)
    }
        
    
    //MARK: - Setup Actions
    
    @objc private func dismissVC() {
        hideLoadingIndicator()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //  MapsVC가 완전히 로딩된 후 실행됨
    @objc private func mapsVCDidLoad() {
        mapsVC?.isTracking = true
        mapsVC?.updateMapPosition(
            lat: avgY ?? LocationManager.shared.currentLatitude,
            lon: avgX ?? LocationManager.shared.currentLongitude
        )
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
    
    private func updateSearchResults(with searchResults: HomeResponse) {
        filteredStoresVC.filteredData = searchResults
        filteredStoresVC.storeData = searchResults.storeList
        filteredStoresVC.reloadCollectionView()
        avgX = searchResults.searchInfo?.avgX
        avgY = searchResults.searchInfo?.avgY
        mapsVCDidLoad()
    }
 

    
    //MARK: - API call
    private func search() {
        showLoadingIndicator()
        let param = SearchRequestManager.shared.currentRequest
        CSearchManager.search(page: 1, param: param) { [weak self] isSuccess, searchResults in
            guard let self = self else { return }
            guard isSuccess, let searchResults = searchResults else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }
            hideLoadingIndicator()
            self.updateSearchResults(with: searchResults)
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


