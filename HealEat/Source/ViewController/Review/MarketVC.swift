// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Combine

class MarketVC: UIViewController {
    
    private var expanded: Bool = true
    
    // MARK: - Init Param
    struct Param {
        let placeId: Int
    }
    var param: Param!
    
    // MARK: - Combine
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Delegate DataSource Handlers
    private var featureCollectionViewHandler = FeatureCollectionViewHandler()
    private var detailRatingCollectionViewHandler = DetailRatingCollectionViewHandler()
    private var previewCollectionViewHandler = PreviewCollectionViewHandler()
    
    private var marketHomeTableViewHandler = MarketHomeTableViewHandler()
    private var imageCollectionViewHandler = ImageCollectionViewHandler()
    private var marketReviewTableViewHandler = MarketReviewTableViewHandler()
    
    // MARK: - API
    private var storeDetailResponseModel: StoreDetailResponseModel?
    private var imageModels: [ImageModel] = []
    
    private var page: Int = 1
    private var isLast: Bool = false
    
    // MARK: - PageViewControllers
    private let marketHomeVC: MarketHomeVC = {
        let viewController = MarketHomeVC()
        viewController.marketHomeView.mainTableView.isScrollEnabled = false
        return viewController
    }()
    private let marketReviewVC: MarketReviewVC = {
        let viewController = MarketReviewVC()
        viewController.marketReviewView.reviewTableView.isScrollEnabled = false
        return viewController
    }()
    private let marketImageVC: MarketImageVC = {
        let viewController = MarketImageVC()
        viewController.marketImageView.imageCollectionView.isScrollEnabled = false
        return viewController
    }()
    
    // MARK: - Basic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketView
        self.navigationController?.navigationBar.isHidden = true
        
        initializeGestures()
        initializeHandlers()
        
        getStoreDetail()
        getReviewImgs()
    }
    
    // MARK: - Func
    private func initializeGestures() {
        marketHomeVC.onGesture = panGestureHandler(recognizer:)
        marketImageVC.onGesture = panGestureHandler(recognizer:)
        marketReviewVC.onGesture = panGestureHandler(recognizer:)
    }
    
    private func initializeHandlers() {
        marketView.featureCollectionView.delegate = featureCollectionViewHandler
        marketView.featureCollectionView.dataSource = featureCollectionViewHandler
        
        marketView.detailRatingCollectionView.delegate = detailRatingCollectionViewHandler
        marketView.detailRatingCollectionView.dataSource = detailRatingCollectionViewHandler
        
        marketView.previewCollectionView.delegate = previewCollectionViewHandler
        marketView.previewCollectionView.dataSource = previewCollectionViewHandler
        
        imageCollectionViewHandler.presentImageViewer = { [weak self] imageModels, index in
            let imageViewerVC = ImageViewerVC()
            imageViewerVC.param = ImageViewerVC.Param(imageModels: imageModels, index: index)
            imageViewerVC.modalPresentationStyle = .overCurrentContext
            imageViewerVC.modalTransitionStyle = .crossDissolve
            self?.present(imageViewerVC, animated: true)
        }
        
        marketHomeTableViewHandler.imageCollectionViewHandler = imageCollectionViewHandler
        marketHomeTableViewHandler.changePageTo = { [weak self] index in
            guard let button = self?.marketView.topTabBar.tabBarStackView.arrangedSubviews[index] as? UIButton else { return }
            self?.marketView.topTabBar.onClickMenu(button)
        }
        marketHomeVC.marketHomeView.mainTableView.delegate = marketHomeTableViewHandler
        marketHomeVC.marketHomeView.mainTableView.dataSource = marketHomeTableViewHandler
        
        marketImageVC.marketImageView.imageCollectionView.delegate = imageCollectionViewHandler
        marketImageVC.marketImageView.imageCollectionView.dataSource = imageCollectionViewHandler
        
        
        marketReviewTableViewHandler.pushWriteReviewVC = { [weak self] in
            let viewController = WriteReviewVC()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        marketReviewVC.marketReviewView.reviewTableView.delegate = marketReviewTableViewHandler
        marketReviewVC.marketReviewView.reviewTableView.dataSource = marketReviewTableViewHandler
    }
    
    private func setStoreToHandlers(storeDetailResponseModel: StoreDetailResponseModel) {
        featureCollectionViewHandler.features = storeDetailResponseModel.storeInfoDto.features
        detailRatingCollectionViewHandler.detailRatings = [
            ("질병 관리", storeDetailResponseModel.isInDBDto.sickScore, storeDetailResponseModel.isInDBDto.sickCount),
            ("베지테리언", storeDetailResponseModel.isInDBDto.vegetScore, storeDetailResponseModel.isInDBDto.vegetCount),
            ("다이어트", storeDetailResponseModel.isInDBDto.dietScore, storeDetailResponseModel.isInDBDto.dietCount),
        ]
        marketHomeTableViewHandler.storeDetailResponseModel = storeDetailResponseModel
        
        marketView.featureCollectionView.reloadData()
        marketView.detailRatingCollectionView.reloadData()
        marketHomeVC.marketHomeView.mainTableView.reloadData()
    }
    
    private func setImagesToHandlers() {
        previewCollectionViewHandler.imageModels = imageModels
        imageCollectionViewHandler.imageModels = imageModels
        
        marketView.previewCollectionView.reloadData()
        marketHomeVC.marketHomeView.mainTableView.reloadData()
        marketImageVC.marketImageView.imageCollectionView.reloadData()
    }
    
    private func initializeView(storeDetailResponseModel: StoreDetailResponseModel) {
        marketView.navigationTitleLabel.text = storeDetailResponseModel.storeInfoDto.placeName
        marketView.titleLabel.text = storeDetailResponseModel.storeInfoDto.placeName
        marketView.subtitleLabel.text = storeDetailResponseModel.storeInfoDto.categoryName
        marketView.ratingStarView.star = storeDetailResponseModel.isInDBDto.totalScore
        marketView.ratingLabel.text = "\(storeDetailResponseModel.isInDBDto.totalScore) (\(storeDetailResponseModel.isInDBDto.reviewCount))"
        marketView.openLabel.text = "영업 중"
        marketView.openHourLabel.text = "9:30 - 20:30"
    }
    
    // MARK: - View
    private lazy var marketView: MarketView = {
        let view = MarketView()
        
        view.topTabBar.delegate = self
        view.pageViewControllers = [
            marketHomeVC,
            marketReviewVC,
            marketImageVC,
        ]
        addChild(view.menuPageViewController)
        view.menuPageViewController.didMove(toParent: self)
        if let pageVC = view.pageViewControllers.first {
            view.menuPageViewController.setViewControllers([pageVC], direction: .forward, animated: false)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.navigationBackButton.addTarget(self, action: #selector(onClickNavBack), for: .touchUpInside)
        view.navigationNaverButton.addTarget(self, action: #selector(onClickNaver), for: .touchUpInside)
        view.bookmarkButton.addTarget(self, action: #selector(onClickBookmark), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func onClickNavBack() {
        
    }
    
    @objc private func onClickNaver() {
        guard let url = storeDetailResponseModel?.storeInfoDto.placeUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func onClickBookmark() {
        marketView.bookmarkButton.isSelected.toggle()
        
    }
    
    // MARK: - PanGesture
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: marketView)
        var height = expanded ? marketView.expandableView.frame.height : 0
        height += translation.y
        
        marketView.updateExpandableAreaView(height: height)
        marketView.navigationNaverButton.alpha = 1 - height / self.marketView.expandableView.frame.height
        marketView.navigationTitleLabel.alpha = 1 - height / marketView.expandableView.frame.height
        
        // Touch Ended: Magnetic Effect
        if recognizer.state == .ended {
            expanded = height > marketView.expandableView.frame.height/2
            height = expanded ? marketView.expandableView.frame.height : 0
            marketHomeVC.marketHomeView.mainTableView.isScrollEnabled = !expanded
            marketReviewVC.marketReviewView.reviewTableView.isScrollEnabled = !expanded
            marketImageVC.marketImageView.imageCollectionView.isScrollEnabled = !expanded
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.marketView.navigationTitleLabel.alpha = 1 - height / self.marketView.expandableView.frame.height
                self.marketView.navigationNaverButton.alpha = 1 - height / self.marketView.expandableView.frame.height
                self.marketView.updateExpandableAreaView(height: height)
                self.marketView.layoutIfNeeded()
            }
            return
        }
    }
    
    // MARK: - Network
    private func getStoreDetail() {
        StoreRepository.shared.getStoreDetail(placeId: param.placeId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { [weak self] storeDetailResponseModel in
                self?.storeDetailResponseModel = storeDetailResponseModel
                self?.initializeView(storeDetailResponseModel: storeDetailResponseModel)
                self?.setStoreToHandlers(storeDetailResponseModel: storeDetailResponseModel)
            })
            .store(in: &cancellable)
    }
    
    private func getReviewImgs() {
        StoreRepository.shared.getReviewImgs(placeId: param.placeId, page: page)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { [weak self] reviewImagesResponseModel in
                reviewImagesResponseModel.reviewImageDtoList.forEach({
                    self?.imageModels.append(ImageModel(reviewImage: $0))
                })
                self?.isLast = reviewImagesResponseModel.isLast
                self?.page += 1
                if reviewImagesResponseModel.totalElements < 10 {
                    self?.getDaumImgs()
                }
                self?.setImagesToHandlers()
            })
            .store(in: &cancellable)
    }
    
    private func getDaumImgs() {
        StoreRepository.shared.getDaumImgs(placeId: param.placeId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { [weak self] daumImageResponseModels in
                daumImageResponseModels.forEach({
                    self?.imageModels.append(ImageModel(daumImage: $0))
                })
                self?.setImagesToHandlers()
            })
            .store(in: &cancellable)
    }
    
}

// MARK: - Delegate
extension MarketVC: TabBarSegmentedControlDelegate {
    func didSelectMenu(direction: UIPageViewController.NavigationDirection, index: Int) {
        marketView.menuPageViewController.setViewControllers([marketView.pageViewControllers[index]], direction: direction, animated: true, completion: nil)
        expanded = false
        marketHomeVC.marketHomeView.mainTableView.isScrollEnabled = true
        marketReviewVC.marketReviewView.reviewTableView.isScrollEnabled = true
        marketImageVC.marketImageView.imageCollectionView.isScrollEnabled = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.marketView.navigationTitleLabel.alpha = 1
            self.marketView.navigationNaverButton.alpha = 1
            self.marketView.updateExpandableAreaView(height: 0)
            self.marketView.layoutIfNeeded()
        }
    }
}
