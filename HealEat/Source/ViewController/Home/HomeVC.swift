//
//  HomeViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.08.
//

import UIKit
import SnapKit
import Then

class HomeVC: UIViewController {
    private var mapsVC: MapsVC?
    private let storeview = StoreView()
    private var modalHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMapsVC()
        setupStore()
    }
    
    private func setupMapsVC() {
        let mapsVC = MapsVC()
        self.mapsVC = mapsVC
        addChild(mapsVC)
        view.addSubview(mapsVC.view)
        mapsVC.view.frame = view.bounds
        mapsVC.didMove(toParent: self)
    }
    
    private func setupStore() {
        // 모달 뷰 설정
        storeview.backgroundColor = .white
        storeview.layer.cornerRadius = 16
        storeview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 상단 모서리만 둥글게
        storeview.clipsToBounds = true
            
        // 모달 뷰를 HomeVC의 뷰에 추가
        view.addSubview(storeview)
        
        storeview.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // 높이 제약 조건 추가 (초기 높이 설정)
        modalHeightConstraint = storeview.heightAnchor.constraint(equalToConstant: 300)
        modalHeightConstraint.isActive = true
            
        // 상단에 그래버 추가
        addGrabber()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            storeview.addGestureRecognizer(panGesture)
    }
    
    private func addGrabber() {
        let grabber = UIView()
        grabber.backgroundColor = .lightGray
        grabber.layer.cornerRadius = 3
        storeview.addSubview(grabber)
        
        grabber.snp.makeConstraints {
            $0.top.equalTo(storeview.snp.top).offset(8)
            $0.centerX.equalTo(storeview.snp.centerX)
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }

    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            // 모달의 높이를 변경
            let newHeight = max(100, modalHeightConstraint.constant - translation.y)
            modalHeightConstraint.constant = newHeight
            gesture.setTranslation(.zero, in: view)
        case .ended:
            // 드래그 종료 후 최종 위치 설정
            if velocity.y > 500 {
                // 드래그 방향이 아래로 빠를 경우 최소 높이로
                modalHeightConstraint.constant = 125
            } else if velocity.y < -500 {
                // 드래그 방향이 위로 빠를 경우 최대 높이로
                modalHeightConstraint.constant = 740
            } else {
                // 속도가 느릴 경우 현재 위치 유지
                let halfHeight = 370
                modalHeightConstraint.constant = modalHeightConstraint.constant > CGFloat(halfHeight) ? 600 : 300
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
