// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // imageCollectionView Cell의 너비 재설정
        self.marketHomeView.mainTableView.reloadData()
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.mainTableView.addGestureRecognizer(panGestureRecognizer)
        
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketHomeView.mainTableView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
}

extension MarketHomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
