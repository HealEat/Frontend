// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketReviewVC: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = marketReviewView
    }
    
    lazy var marketReviewView: MarketReviewView = {
        let view = MarketReviewView()
        return view
    }()
}

