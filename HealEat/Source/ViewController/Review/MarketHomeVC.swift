// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        view.mainScrollView.delegate = self
        return view
    }()
}

extension MarketHomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
//        scrollView.contentOffset.y = 0
    }
}
