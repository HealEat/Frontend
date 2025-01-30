// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketImageVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketImageView
    }
    
    lazy var marketImageView: MarketImageView = {
        let view = MarketImageView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.imageCollectionView.addGestureRecognizer(panGestureRecognizer)
        
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketImageView.imageCollectionView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
}

extension MarketImageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
