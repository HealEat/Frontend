// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class FilteredSearchVC: UIViewController {
    // MARK: - UI Properties
    private var mapsVC: MapsVC?
    private let filteredStoreView = FilteredStoresView()
    private var modalHeightConstraint: NSLayoutConstraint!
    private var storePanGesture: UIPanGestureRecognizer?
    public var filteredStoresVC = FilteredStoresVC() // StoreVC 추가
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapsVC()
        //setupModalVC()
        setupStoresVC()
        setupSearchBar()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        panGesture.cancelsTouchesInView = false  // ✅ 부모 뷰(MapView) 터치도 정상적으로 전달되도록 설정
        view.addGestureRecognizer(panGesture)
    }
    
    private func setupSearchBar() {
        let searchBar = MapSearchBar().then {
            $0.dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            let placeholder = NSAttributedString(string: "검색", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.healeatGray5
            ])
            $0.searchBar.attributedPlaceholder = placeholder
            
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
    }
    
    private func setupModalVC() {
        let vc = NewBottomSheetVC()
        let navVC = UINavigationController(rootViewController: vc)

            navVC.isModalInPresentation = true  // ✅ Bottom Sheet를 완전히 닫을 수 없도록 설정
        navVC.view.backgroundColor = .clear

            if let sheet = navVC.sheetPresentationController {
                sheet.preferredCornerRadius = 40  // ✅ 둥근 모서리
                sheet.detents = [
                    .custom(resolver: { context in
                        0.1 * context.maximumDetentValue // ✅ 화면 높이의 10% (아주 작은 상태)
                    }),
                    .medium(), // ✅ 추가: medium 상태 (중간 크기)
                    .large() // ✅ 기존 large 상태 (최대 크기)
                ]
                sheet.prefersGrabberVisible = true  // ✅ 상단에 Grabber 표시 (사용자가 쉽게 드래그할 수 있도록)

                sheet.largestUndimmedDetentIdentifier = .medium // ✅ medium 이하 상태에서는 배경을 흐리지 않음
            }

            navigationController?.present(navVC, animated: true)
    }
    
    private func setupStoresVC() {
        filteredStoreView.backgroundColor = .white
        filteredStoreView.layer.cornerRadius = 16
        filteredStoreView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filteredStoreView.clipsToBounds = true
            
        view.addSubview(filteredStoreView)
            
        filteredStoreView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
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
    
        
    
    //MARK: - Setup Actions
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let screenHeight = UIScreen.main.bounds.height - 130
        let collectionView = filteredStoresVC.storeview.storeCollectionView

            // 컬렉션뷰가 스크롤 중이면 StoreView 팬 제스처 비활성화
        if collectionView.contentOffset.y > 0 {
            return
        }
        
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
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }

    
    //MARK: - API call
    
    
  

}


extension FilteredSearchVC: UIGestureRecognizerDelegate {
    // 컬렉션뷰와 StoreView의 스크롤을 동시에 인식하게 함
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // 컬렉션뷰가 터치 이벤트를 받으면 StoreView 팬 제스처를 비활성화
        if otherGestureRecognizer.view is UICollectionView {
                    return false
        }
        return true
    }

}

extension FilteredSearchVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 컬렉션뷰가 스크롤될 때 StoreView 팬 제스처 제거
        if scrollView == filteredStoresVC.storeview.storeCollectionView && scrollView.contentOffset.y > 0 {
            filteredStoreView.removeGestureRecognizer(storePanGesture!)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 컬렉션뷰가 최상단에 도달하면 다시 팬 제스처 활성화
        if scrollView == filteredStoresVC.storeview.storeCollectionView && scrollView.contentOffset.y == 0 {
            if filteredStoreView.gestureRecognizers?.contains(storePanGesture!) == false {
                filteredStoreView.addGestureRecognizer(storePanGesture!)
            }
        }
    }
}

