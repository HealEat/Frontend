// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketView
    }
    
    private lazy var marketView: MarketView = {
        let view = MarketView()
        
        let marketHomeVC = MarketHomeVC()
        view.pageViewControllers = [
            marketHomeVC,
            MarketReviewVC(),
            MarketHomeVC(),
        ]
        view.topTabBar.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        view.addGestureRecognizer(panGestureRecognizer)
        addChild(view.menuPageViewController)
        view.menuPageViewController.didMove(toParent: self)
        return view
    }()
    
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: marketView)
        var height = marketView.expanded ? GlobalConst.marketScrolledAreaHeightConstraint : 0
        height += translation.y
        marketView.updateExpandableAreaView(height: height)
        
        if recognizer.state == .ended {
            if height > 0 {
                if height < GlobalConst.marketScrolledAreaHeightConstraint/2 {
                    height = 0
                    marketView.expanded = false
                } else {
                    height = GlobalConst.marketScrolledAreaHeightConstraint
                    marketView.expanded = true
                }
            }
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.marketView.updateExpandableAreaView(height: height)
                self?.marketView.layoutIfNeeded()
            }
            return
        }
        marketView.updateExpandableAreaView(height: height)
    }
}

extension MarketVC: TabBarSegmentedControlDelegate {
    func didSelectMenu(direction: UIPageViewController.NavigationDirection, index: Int) {
        marketView.menuPageViewController.setViewControllers([marketView.pageViewControllers[index]], direction: direction, animated: true, completion: nil)
        print(index)
    }
}
