// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketVC: UIViewController {

    private let typeCollectionViewHandler = TypeCollectionViewHandler(types: [
        "속 편한 음식",
        "야채",
        "죽",
        "따뜻한 음식",
    ])
    private let detailRatingCollectionViewHandler = DetailRatingCollectionViewHandler(detailRatings: [
        ("질병 관리", 4.7, 15),
        ("베지테리언", 3.4, 13),
        ("다이어트", 4.3, 5),
    ])
    private let previewCollectionViewHandler = PreviewCollectionViewHandler(urls: [
        URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
    ])
    
    private var imageCollectionViewHandler = ImageCollectionViewHandler(urls: [
        URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
    ])
    
    private let reviewTableViewHandler = ReviewTableViewHandler()
    
    private let marketHomeVC: MarketHomeVC = {
        let viewController = MarketHomeVC()
        viewController.marketHomeView.locationLabel.text = "서울 마포구 홍익로 10 106호"
        viewController.marketHomeView.openLabel.text = "영업 중"
        viewController.marketHomeView.openHourLabel.text = "9:30 - 20:30"
        viewController.marketHomeView.reviewTitleLabel.text = "'본죽&비빔밥cafe 홍대점'의\n건강 평점을 남겨주세요!"
        viewController.marketHomeView.mainScrollView.isUserInteractionEnabled = false
        return viewController
    }()
    
    private let marketImageVC: MarketImageVC = {
        let viewController = MarketImageVC()
        viewController.marketImageView.imageCollectionView.isUserInteractionEnabled = false
        return viewController
    }()
    
    private let marketReviewVC: MarketReviewVC = {
        let viewController = MarketReviewVC()
        viewController.marketReviewView.reviewTableView.isUserInteractionEnabled = false
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketView
        self.navigationController?.navigationBar.isHidden = true
        
        marketHomeVC.onGesture = panGestureHandler(recognizer:)
        marketHomeVC.changePageTo = { [weak self] index in
            guard let button = self?.marketView.topTabBar.tabBarStackView.arrangedSubviews[index] as? UIButton else { return }
            self?.marketView.topTabBar.onClickMenu(button)
        }
        marketHomeVC.marketHomeView.imageCollectionView.dataSource = imageCollectionViewHandler
        marketHomeVC.marketHomeView.imageCollectionView.delegate = imageCollectionViewHandler
        
        marketImageVC.onGesture = panGestureHandler(recognizer:)
        marketImageVC.marketImageView.imageCollectionView.dataSource = imageCollectionViewHandler
        marketImageVC.marketImageView.imageCollectionView.delegate = imageCollectionViewHandler
        
        marketReviewVC.onGesture = panGestureHandler(recognizer:)
        reviewTableViewHandler.pushWriteReviewVC = { [weak self] in
            let viewController = WriteReviewVC()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        marketReviewVC.marketReviewView.reviewTableView.dataSource = reviewTableViewHandler
        marketReviewVC.marketReviewView.reviewTableView.delegate = reviewTableViewHandler
    }
    
    private lazy var marketView: MarketView = {
        let view = MarketView()
        
        view.pageViewControllers = [
            marketHomeVC,
            marketImageVC,
            marketReviewVC,
        ]
        view.topTabBar.delegate = self
        view.navigationTitleLabel.text = "본죽&비빔밥cafe 홍대점"
        view.titleLabel.text = "본죽&비빔밥cafe 홍대점"
        view.subtitleLabel.text = "죽"
        view.ratingStarView.star = 4.4
        view.ratingLabel.text = "4.4 (23)"
        view.openLabel.text = "영업 중"
        view.openHourLabel.text = "9:30 - 20:30"
        
        view.typeCollectionView.delegate = typeCollectionViewHandler
        view.typeCollectionView.dataSource = typeCollectionViewHandler
        
        view.detailRatingCollectionView.delegate = detailRatingCollectionViewHandler
        view.detailRatingCollectionView.dataSource = detailRatingCollectionViewHandler
        
        view.previewCollectionView.delegate = previewCollectionViewHandler
        view.previewCollectionView.dataSource = previewCollectionViewHandler
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        view.addGestureRecognizer(panGestureRecognizer)
        addChild(view.menuPageViewController)
        view.menuPageViewController.didMove(toParent: self)
        if let pageVC = view.pageViewControllers.first {
            view.menuPageViewController.setViewControllers([pageVC], direction: .forward, animated: false)
        }
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: marketView)
        var height = marketView.expanded ? marketView.expandableView.frame.height : 0
        height += translation.y
        marketView.updateExpandableAreaView(height: height)
        marketView.navigationTitleLabel.alpha = 1 - height / marketView.expandableView.frame.height
        if recognizer.state == .ended {
            if height < marketView.expandableView.frame.height/2 {
                height = 0
                marketView.expanded = false
                marketHomeVC.marketHomeView.mainScrollView.isUserInteractionEnabled = true
                marketImageVC.marketImageView.imageCollectionView.isUserInteractionEnabled = true
                marketReviewVC.marketReviewView.reviewTableView.isUserInteractionEnabled = true
            } else {
                height = marketView.expandableView.frame.height
                marketView.expanded = true
                marketHomeVC.marketHomeView.mainScrollView.isUserInteractionEnabled = false
                marketImageVC.marketImageView.imageCollectionView.isUserInteractionEnabled = false
                marketReviewVC.marketReviewView.reviewTableView.isUserInteractionEnabled = false
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.marketView.navigationTitleLabel.alpha = 1 - height / self.marketView.expandableView.frame.height
                self.marketView.updateExpandableAreaView(height: height)
                self.marketView.layoutIfNeeded()
            }
            return
        }
        marketView.updateExpandableAreaView(height: height)
    }
}

extension MarketVC: TabBarSegmentedControlDelegate {
    func didSelectMenu(direction: UIPageViewController.NavigationDirection, index: Int) {
        marketView.menuPageViewController.setViewControllers([marketView.pageViewControllers[index]], direction: direction, animated: true, completion: nil)
        marketView.expanded = false
        marketHomeVC.marketHomeView.mainScrollView.isUserInteractionEnabled = true
        marketImageVC.marketImageView.imageCollectionView.isUserInteractionEnabled = true
        marketReviewVC.marketReviewView.reviewTableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.marketView.navigationTitleLabel.alpha = 1
            self.marketView.updateExpandableAreaView(height: 0)
            self.marketView.layoutIfNeeded()
        }
    }
}
