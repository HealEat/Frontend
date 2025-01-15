//
//  MarketVC.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.15.
//

import UIKit

class MarketVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketView
    }
    
    private lazy var marketView: MarketView = {
        let view = MarketView()
        view.topTabBar.delegate = self
        return view
    }()
}

extension MarketVC: TabBarSegmentedControlDelegate {
    func didSelectMenu(index: Int) {
        print(index)
    }
}
