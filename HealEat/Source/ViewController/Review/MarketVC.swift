// Copyright © 2025 HealEat. All rights reserved.

import UIKit

protocol InnerScrollDelegate: NSObject {
    func expand()
    func shrink()
}

class MarketVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketView
    }
    
    private lazy var marketView: MarketView = {
        let view = MarketView()
        let marketHomeVC = MarketHomeVC()
        marketHomeVC.delegate = self
        view.pageViewControllers = [
            marketHomeVC,
            MarketReviewVC(),
            MarketHomeVC(),
            MarketReviewVC(),
        ]
        view.topTabBar.delegate = self
        addChild(view.menuPageViewController)
        view.menuPageViewController.didMove(toParent: self)
        return view
    }()
    
    
}

extension MarketVC: TabBarSegmentedControlDelegate {
    func didSelectMenu(direction: UIPageViewController.NavigationDirection, index: Int) {
        marketView.menuPageViewController.setViewControllers([marketView.pageViewControllers[index]], direction: direction, animated: true, completion: nil)
        print(index)
    }
}

extension MarketVC: InnerScrollDelegate {
    func expand() {
        print("EXPAND")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.marketView.expandArea()
            self?.marketView.layoutIfNeeded()
        }
        
    }
    
    func shrink() {
        print("SHRINK")
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.marketView.shrinkArea()
            self?.marketView.layoutIfNeeded()
        }
    }
}
