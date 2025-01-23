// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        view.mainScrollView.isUserInteractionEnabled = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.mainScrollView.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketHomeView.mainScrollView.contentOffset.y != 0 {
            return
        }
        onGesture?(recognizer)
    }
    
}

extension MarketHomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
