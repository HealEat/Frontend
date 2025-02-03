// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class WriteReviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = writeReviewView
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        view.navigationTitleLabel.text = "본죽&비빔밥cafe 홍대점"
        view.topTitleLabel.text = "'본죽&비빔밥cafe 홍대점'의\n건강 평점을 남겨주세요!"
        view.ratingReviewView.initializeView(totalScore: 4.4, totalCount: 23, tasteScore: 0, cleanScore: 0, freshScore: 0, nutritionScore: 0)
        view.reviewTitleLabel.text = "후기를 작성해주세요!"
        view.reviewSubLabel.text = "사진 최대 10장, 글자 최대 300자"
        view.navigationBackButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return view
    }()
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
