// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class WriteReviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = writeReviewView
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        return view
    }()
    
}
