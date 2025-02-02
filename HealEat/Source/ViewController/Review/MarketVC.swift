// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Combine

class MarketVC: UIViewController {
    
    // MARK: - Init Param
    struct Param {
        let storeResponseModel: StoreResponseModel
    }
    var param: Param!
    
    // MARK: - Combine
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Delegate DataSource Handlers
    private var typeCollectionViewHandler: TypeCollectionViewHandler?
    private var detailRatingCollectionViewHandler: DetailRatingCollectionViewHandler?
    private var previewCollectionViewHandler: PreviewCollectionViewHandler?
    private var imageCollectionViewHandler: ImageCollectionViewHandler?
    private var reviewTableViewHandler: ReviewTableViewHandler?
    
    // MARK: - PageViewControllers
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
    
    // MARK: - Basic
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
        
        param.storeResponseModel.isInDB ? getStoreDetail() : saveStore()
    }
    
    // MARK: - Init Func
    private func initializeGestures() {
        marketHomeVC.onGesture = panGestureHandler(recognizer:)
        marketImageVC.onGesture = panGestureHandler(recognizer:)
        marketReviewVC.onGesture = panGestureHandler(recognizer:)
    }
    
    // MARK: - Func
    private func initializeHandlers() {
        typeCollectionViewHandler = TypeCollectionViewHandler(types: param.storeResponseModel.features)
        marketView.typeCollectionView.delegate = typeCollectionViewHandler
        marketView.typeCollectionView.dataSource = typeCollectionViewHandler
        
        detailRatingCollectionViewHandler = DetailRatingCollectionViewHandler(detailRatings: [
            ("질병 관리", param.storeResponseModel.sickScore, param.storeResponseModel.sickCount),
            ("베지테리언", param.storeResponseModel.vegetScore, param.storeResponseModel.vegetCount),
            ("다이어트", param.storeResponseModel.dietScore, param.storeResponseModel.dietCount),
        ])
        marketView.detailRatingCollectionView.delegate = detailRatingCollectionViewHandler
        marketView.detailRatingCollectionView.dataSource = detailRatingCollectionViewHandler
        
        previewCollectionViewHandler = PreviewCollectionViewHandler(urls: param.storeResponseModel.imageUrls)
        marketView.previewCollectionView.delegate = previewCollectionViewHandler
        marketView.previewCollectionView.dataSource = previewCollectionViewHandler
        
        imageCollectionViewHandler = ImageCollectionViewHandler(urls: param.storeResponseModel.imageUrls)
        imageCollectionViewHandler?.presentImageViewer = { [weak self] imageModel in
            let imageViewerVC = ImageViewerVC()
            imageViewerVC.param = ImageViewerVC.Param(imageModel: imageModel)
            imageViewerVC.modalPresentationStyle = .overCurrentContext
            imageViewerVC.modalTransitionStyle = .crossDissolve
            self?.present(imageViewerVC, animated: true)
        }
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
        marketView.navigationTitleLabel.text = param.storeResponseModel.placeName
        marketView.titleLabel.text = param.storeResponseModel.placeName
        marketView.subtitleLabel.text = param.storeResponseModel.categoryName
        marketView.ratingStarView.star = param.storeResponseModel.totalScore
        marketView.ratingLabel.text = "\(param.storeResponseModel.totalScore) (\(param.storeResponseModel.reviewCount))"
        marketView.openLabel.text = "영업 중"
        marketView.openHourLabel.text = "9:30 - 20:30"
        
        marketHomeVC.marketHomeView.locationLabel.text = param.storeResponseModel.addressName
        marketHomeVC.marketHomeView.openLabel.text = "영업 중"
        marketHomeVC.marketHomeView.openHourLabel.text = "9:30 - 20:30"
        marketHomeVC.marketHomeView.reviewTitleLabel.text = "'\(param.storeResponseModel.placeName)'의\n건강 평점을 남겨주세요!"
    }
    
    // MARK: - View
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
    
    // MARK: - PanGesture
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
    
    // MARK: - Network
    private func saveStore() {
        let saveStoreRequest = SaveStoreRequest(
            placeId: "\(param.storeResponseModel.placeId)",
            placeName: param.storeResponseModel.placeName,
            categoryName: param.storeResponseModel.categoryName,
            phone: param.storeResponseModel.phone,
            addressName: param.storeResponseModel.addressName,
            roadAddressName: param.storeResponseModel.roadAddressName,
            x: param.storeResponseModel.x,
            y: param.storeResponseModel.y,
            placeUrl: param.storeResponseModel.placeUrl.absoluteString,
            daumImgUrlList: param.storeResponseModel.imageUrls.map({ $0.absoluteString })
        )
        StoreRepository.shared.saveStore(saveStoreRequest: saveStoreRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { result in
                print(result)
            })
            .store(in: &cancellable)
    }
    
    private func getStoreDetail() {
        StoreRepository.shared.getStoreDetail(storeId: param.storeResponseModel.placeId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { result in
                print(result)
            })
            .store(in: &cancellable)
    }
}

// MARK: - Delegate
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
