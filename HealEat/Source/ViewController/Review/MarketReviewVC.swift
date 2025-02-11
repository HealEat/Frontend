// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Combine

class MarketReviewVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketReviewView
    }
    
    lazy var marketReviewView: MarketReviewView = {
        let view = MarketReviewView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.reviewTableView.addGestureRecognizer(panGestureRecognizer)
        
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketReviewView.reviewTableView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
}

extension MarketReviewVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
