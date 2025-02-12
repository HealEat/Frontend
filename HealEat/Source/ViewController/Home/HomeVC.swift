//  HomeViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.08.
//
// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SnapKit
import Then

class HomeVC: UIViewController {
    private var mapsVC: MapsVC?
    private let storeview = StoreView()
    private let notloginview = NotloginView()
    private let healthsettingview = HealthInfoSettingView()
    public var storeVC = StoreVC() // StoreVC 추가
    private var modalHeightConstraint: NSLayoutConstraint!
    private var storePanGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapsVC()
        if !storeVC.isloggedIn {
            setupNotloginView()
        }
        else {
            if !storeVC.hasHealthInfo {
                setupStoreView()
                storeVC.delegate = self
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.storeVC.reloadCollectionView() // StoreVC에서 컬렉션 뷰 강제 리로드
                }
            }
            else {
                setupHealthSettingView()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storeVC.reloadCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupMapsVC() {
        let mapsVC = MapsVC()
        self.mapsVC = mapsVC
        addChild(mapsVC)
        view.addSubview(mapsVC.view)
        mapsVC.view.frame = view.bounds
        mapsVC.didMove(toParent: self)
        
        mapsVC.onLocationUpdate = { [weak self] lat, lon in
            self?.storeVC.updateLocation(lat: lat, lon: lon)
        }
    }
        
    private func setupStoreView() {
        storeview.backgroundColor = .white
        storeview.layer.cornerRadius = 16
        storeview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        storeview.clipsToBounds = true
            
        view.addSubview(storeview)
            
        storeview.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(370)
        }
        
        _ = UIScreen.main.bounds.height - 130
        modalHeightConstraint = storeview.heightAnchor.constraint(equalToConstant: 370)
        modalHeightConstraint.isActive = true
            
        DispatchQueue.main.async {
            self.addGrabber()
        }
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        storePanGesture = panGesture
        storePanGesture?.delegate = self
        storeview.addGestureRecognizer(panGesture)

        //StoreVC 추가
        addChild(storeVC)
        storeview.addSubview(storeVC.view)
        storeVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        storeVC.didMove(toParent: self)
        
        storeVC.storeview.storeCollectionView.isScrollEnabled = true
    }
    
    private func setupHealthSettingView() {
        healthsettingview.backgroundColor = .white
        healthsettingview.layer.cornerRadius = 16
        healthsettingview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        healthsettingview.clipsToBounds = true
            
        view.addSubview(healthsettingview)
            
        healthsettingview.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        _ = UIScreen.main.bounds.height - 130
        modalHeightConstraint = healthsettingview.heightAnchor.constraint(equalToConstant: 370)
        modalHeightConstraint.isActive = true
            
        DispatchQueue.main.async {
            self.addGrabber()
        }
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        storePanGesture = panGesture
        storePanGesture?.delegate = self
        healthsettingview.addGestureRecognizer(panGesture)

        //StoreVC 추가
        addChild(storeVC)
        healthsettingview.addSubview(storeVC.view)
        storeVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        storeVC.didMove(toParent: self)

    }
    
    private func setupNotloginView() {
        notloginview.backgroundColor = .white
        notloginview.layer.cornerRadius = 16
        notloginview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        notloginview.clipsToBounds = true
            
        view.addSubview(notloginview)
            
        notloginview.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        _ = UIScreen.main.bounds.height - 130
        modalHeightConstraint = notloginview.heightAnchor.constraint(equalToConstant: 370)
        modalHeightConstraint.isActive = true
            
        DispatchQueue.main.async {
            self.addGrabber()
        }
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        storePanGesture = panGesture
        storePanGesture?.delegate = self
        notloginview.addGestureRecognizer(panGesture)

        //StoreVC 추가
        addChild(storeVC)
        notloginview.addSubview(storeVC.view)
        storeVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        storeVC.didMove(toParent: self)
    }
    
    private func addGrabber() {
        let grabber = UIView()
        grabber.backgroundColor = .lightGray
        grabber.layer.cornerRadius = 3
        let parentView = storeVC.isloggedIn ? storeview : notloginview

        parentView.addSubview(grabber)

        grabber.snp.makeConstraints {
            $0.top.equalTo(parentView.snp.top).offset(8)
            $0.centerX.equalTo(parentView.snp.centerX)
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
    }
    
    @objc private func healthsetting() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let window = windowScene.windows.first else { return }
        
        lazy var dimmedBackgroundView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            $0.frame = view.bounds
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        window.addSubview(dimmedBackgroundView)
        
        lazy var alertView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
        }
        
        dimmedBackgroundView.addSubview(alertView)

        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(288)
            $0.height.equalTo(218)
        }

        lazy var messageLabel = UILabel().then {
            $0.text = "건강 정보가 이미 설정되어 있습니다.\n다시 설정하시겠습니까?"
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            $0.numberOfLines = 0
            $0.textColor = .black
        }
        
        alertView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(alertView).offset(55.5)
            $0.leading.trailing.equalTo(alertView).inset(45)
        }
        // 버튼 추가
        lazy var buttonStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
                
        alertView.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(alertView).offset(-55.5)
            $0.leading.equalTo(alertView).offset(45)
            $0.width.equalTo(198)
            $0.height.equalTo(33)
        }

        // "예" 버튼
        lazy var yesButton = UIButton().then {
            $0.setTitle("예", for: .normal)
            $0.setTitleColor(.black , for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.00)
            $0.layer.cornerRadius = 12
        }
                
        buttonStackView.addArrangedSubview(yesButton)

        // "아니요" 버튼
        lazy var noButton = UIButton().then {
            $0.setTitle("아니요", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.00)
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(tapnoButton), for: .touchUpInside)
        }
        
        buttonStackView.addArrangedSubview(noButton)
        dimmedBackgroundView.tag = 1
                
    }
    
    private func dismissAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let window = windowScene.windows.first else { return }
        window.viewWithTag(1)?.removeFromSuperview()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let screenHeight = UIScreen.main.bounds.height - 130
        let collectionView = storeVC.storeview.storeCollectionView

        
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
    
    @objc private func tapnoButton() {
        dismissAlert()
    }

}

extension HomeVC: StoreVCDelegate {
    func didTapHealthSetting() {
        healthsetting() // 기존 healthsetting() 메서드 호출
    }
}

extension HomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let collectionView = otherGestureRecognizer.view as? UICollectionView {
            return collectionView.contentOffset.y <= 0
        }
        return false
    }
}


