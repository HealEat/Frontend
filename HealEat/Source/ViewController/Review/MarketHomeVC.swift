//
//  MarketHomeVC.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.18.
//

import UIKit

class MarketHomeVC: UIViewController {
    
    weak var delegate: InnerScrollDelegate?

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
//        print(scrollView.contentOffset)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 {
            delegate?.expand()
        } else if scrollView.contentOffset.y > 0 {
            delegate?.shrink()
        }
    }
}
