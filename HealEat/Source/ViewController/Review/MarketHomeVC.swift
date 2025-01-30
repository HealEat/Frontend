// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    var changePageTo: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // imageCollectionView Cell의 너비 재설정
        self.marketHomeView.imageCollectionView.reloadData()
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.mainScrollView.addGestureRecognizer(panGestureRecognizer)
        
        view.imageMoreButton.addTarget(self, action: #selector(onClickImageMoreButton), for: .touchUpInside)
        view.reviewMoreButton.addTarget(self, action: #selector(onClickReviewMoreButton), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketHomeView.mainScrollView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
    
    @objc private func onClickImageMoreButton() {
        changePageTo?(1)
    }
    @objc private func onClickReviewMoreButton() {
        changePageTo?(2)
    }
}

extension MarketHomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
