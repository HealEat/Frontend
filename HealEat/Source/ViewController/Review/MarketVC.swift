// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketVC: UIViewController {
    
    struct Param {
        
        let placeId: Int
        let placeName: String
        let categoryName: String
        let phone: String
        let addressName: String
        let roadAddressName: String
        let x: String
        let y: String
        let placeUrl: URL
        let features: [String]
        let imageUrls: [URL]
        
        let isInDB: Bool
        
        let totalScore: Float
        let reviewCount: Int
        let sickScore: Float
        let sickCount: Int
        let vegetScore: Float
        let vegetCount: Int
        let dietScore: Float
        let dietCount: Int
        
        let isBookMarked: Bool
        
//        let reviews: [Review]
//        struct Review {
//            let name: String
//            let reviewId: Int
//            let totalScore: Float
//            let body: String
//            let createdAt: Date
//        }
    }
    
    var param: Param!
    
    private var typeCollectionViewHandler: TypeCollectionViewHandler?
    private var detailRatingCollectionViewHandler: DetailRatingCollectionViewHandler?
    private var previewCollectionViewHandler: PreviewCollectionViewHandler?
    private var imageCollectionViewHandler: ImageCollectionViewHandler?
    private var reviewTableViewHandler: ReviewTableViewHandler?
    
    private let marketHomeVC: MarketHomeVC = {
        let viewController = MarketHomeVC()
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
        
        marketHomeVC.changePageTo = { [weak self] index in
            guard let button = self?.marketView.topTabBar.tabBarStackView.arrangedSubviews[index] as? UIButton else { return }
            self?.marketView.topTabBar.onClickMenu(button)
        }
        initializeView()
        initializeGestures()
        initializeHandlers()
        
        if !param.isInDB {
            saveStore()
        }
    }
    
    private func initializeGestures() {
        marketHomeVC.onGesture = panGestureHandler(recognizer:)
        marketImageVC.onGesture = panGestureHandler(recognizer:)
        marketReviewVC.onGesture = panGestureHandler(recognizer:)
    }
    
    private func initializeHandlers() {
        typeCollectionViewHandler = TypeCollectionViewHandler(types: param.features)
        marketView.typeCollectionView.delegate = typeCollectionViewHandler
        marketView.typeCollectionView.dataSource = typeCollectionViewHandler
        
        detailRatingCollectionViewHandler = DetailRatingCollectionViewHandler(detailRatings: [
            ("질병 관리", param.sickScore, param.sickCount),
            ("베지테리언", param.vegetScore, param.vegetCount),
            ("다이어트", param.dietScore, param.dietCount),
        ])
        marketView.detailRatingCollectionView.delegate = detailRatingCollectionViewHandler
        marketView.detailRatingCollectionView.dataSource = detailRatingCollectionViewHandler
        
        previewCollectionViewHandler = PreviewCollectionViewHandler(urls: param.imageUrls)
        marketView.previewCollectionView.delegate = previewCollectionViewHandler
        marketView.previewCollectionView.dataSource = previewCollectionViewHandler
        
        imageCollectionViewHandler = ImageCollectionViewHandler(urls: param.imageUrls)
        marketHomeVC.marketHomeView.imageCollectionView.dataSource = imageCollectionViewHandler
        marketHomeVC.marketHomeView.imageCollectionView.delegate = imageCollectionViewHandler
        marketImageVC.marketImageView.imageCollectionView.dataSource = imageCollectionViewHandler
        marketImageVC.marketImageView.imageCollectionView.delegate = imageCollectionViewHandler
        
        reviewTableViewHandler = ReviewTableViewHandler()
        reviewTableViewHandler?.pushWriteReviewVC = { [weak self] in
            let viewController = WriteReviewVC()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        marketReviewVC.marketReviewView.reviewTableView.dataSource = reviewTableViewHandler
        marketReviewVC.marketReviewView.reviewTableView.delegate = reviewTableViewHandler
    }
    
    private func initializeView() {
        marketView.navigationTitleLabel.text = param.placeName
        marketView.titleLabel.text = param.placeName
        marketView.subtitleLabel.text = param.categoryName
        marketView.ratingStarView.star = param.totalScore
        marketView.ratingLabel.text = "\(param.totalScore) (\(param.reviewCount))"
        marketView.openLabel.text = "영업 중"
        marketView.openHourLabel.text = "9:30 - 20:30"
        
        marketHomeVC.marketHomeView.locationLabel.text = param.addressName
        marketHomeVC.marketHomeView.openLabel.text = "영업 중"
        marketHomeVC.marketHomeView.openHourLabel.text = "9:30 - 20:30"
        marketHomeVC.marketHomeView.reviewTitleLabel.text = "'\(param.placeName)'의\n건강 평점을 남겨주세요!"
    }
    
    private lazy var marketView: MarketView = {
        let view = MarketView()
        
        view.pageViewControllers = [
            marketHomeVC,
            marketImageVC,
            marketReviewVC,
        ]
        view.topTabBar.delegate = self
        
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
    
    private func saveStore() {
        let saveStoreRequest = SaveStoreRequest(
            placeId: "\(param.placeId)",
            placeName: param.placeName,
            categoryName: param.categoryName,
            phone: param.phone,
            addressName: param.addressName,
            roadAddressName: param.roadAddressName,
            x: param.x,
            y: param.y,
            placeUrl: param.placeUrl.absoluteString,
            daumImgUrlList: param.imageUrls.map({ $0.absoluteString })
        )
        StoreRepository.shared.saveStore(saveStoreRequest: saveStoreRequest)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { result in
                if !result.isSuccess {
                    print("FAIL: Save Store")
                    print(result)
                }
                print(result)
            })
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
