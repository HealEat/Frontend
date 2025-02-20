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
    private var imageCollectionViewHandler = ImageCollectionViewHandler()
    
    // MARK: - API
    private var storeDetailResponseModel: StoreDetailResponseModel?
    
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
        
        initializeViewControllers()
        initializeHandlers()
        bind()
        getStoreDetail(placeId: param.placeId)
    }
    
    // MARK: - Func
    private func initializeViewControllers() {
        marketHomeVC.onGesture = panGestureHandler(recognizer:)
        marketHomeVC.imageCollectionViewHandler = imageCollectionViewHandler
        marketHomeVC.changePageTo = { [weak self] index in
            guard let button = self?.marketView.topTabBar.tabBarStackView.arrangedSubviews[index] as? UIButton else { return }
            self?.marketView.topTabBar.onClickMenu(button)
        }
        
        marketImageVC.onGesture = panGestureHandler(recognizer:)
        marketReviewVC.onGesture = panGestureHandler(recognizer:)
        marketReviewVC.param = MarketReviewVC.Param(placeId: param.placeId)
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
        
        marketImageVC.marketImageView.imageCollectionView.delegate = imageCollectionViewHandler
        marketImageVC.marketImageView.imageCollectionView.dataSource = imageCollectionViewHandler
    }
    
    private func setStoreToHandlers(storeDetailResponseModel: StoreDetailResponseModel) {
        featureCollectionViewHandler.features = storeDetailResponseModel.storeInfoDto.features
        detailRatingCollectionViewHandler.detailRatings = [
            ("질병 관리", storeDetailResponseModel.isInDBDto.sickScore, storeDetailResponseModel.isInDBDto.sickCount),
            ("베지테리언", storeDetailResponseModel.isInDBDto.vegetScore, storeDetailResponseModel.isInDBDto.vegetCount),
            ("다이어트", storeDetailResponseModel.isInDBDto.dietScore, storeDetailResponseModel.isInDBDto.dietCount),
        ]
        marketHomeVC.storeDetailResponseModel = storeDetailResponseModel
        marketReviewVC.storeDetailResponseModel = storeDetailResponseModel
        
        marketView.featureCollectionView.reloadData()
        marketView.detailRatingCollectionView.reloadData()
        marketHomeVC.marketHomeView.mainTableView.reloadData()
    }
    
    private func reloadImages() {
        marketView.previewCollectionView.reloadData()
        marketHomeVC.marketHomeView.mainTableView.reloadData()
        marketImageVC.marketImageView.imageCollectionView.reloadData()
    }
    
    private func initializeView(storeDetailResponseModel: StoreDetailResponseModel) {
        marketView.navigationTitleLabel.text = storeDetailResponseModel.storeInfoDto.placeName
        marketView.titleLabel.text = storeDetailResponseModel.storeInfoDto.placeName
        marketView.subtitleLabel.text = storeDetailResponseModel.storeInfoDto.categoryName
        marketView.bookmarkButton.isSelected = storeDetailResponseModel.bookmarkId != nil
        marketView.ratingStarView.star = storeDetailResponseModel.isInDBDto.totalHealthScore
        marketView.ratingLabel.text = "\(storeDetailResponseModel.isInDBDto.reviewCount == 0 ? "리뷰 없음" : storeDetailResponseModel.isInDBDto.totalHealthScore.oneDecimalString) (\(storeDetailResponseModel.isInDBDto.reviewCount))"
        marketView.openLabel.text = "영업 중"
        marketView.openHourLabel.text = "9:30 - 20:30"
    }
    
    private func bind() {
        imageCollectionViewHandler.requestImages
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                getReviewImgs(placeId: param.placeId, page: imageCollectionViewHandler.page)
            })
            .store(in: &cancellable)
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
        dismiss(animated: true)
    }
    
    @objc private func onClickNaver() {
        guard let url = storeDetailResponseModel?.storeInfoDto.placeUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func onClickBookmark() {
        BearerTokenPlugin().checkAuthenticationStatus(completion: { [weak self] token in
            guard let self = self else { return }
            if token == nil {
                let alertDismiss: UIAlertController = UIAlertController(title: "로그인이 필요합니다.", message: "", preferredStyle: .alert)
                let actionOk: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                alertDismiss.addAction(actionOk)
                present(alertDismiss, animated: true, completion: nil)
                return
            }
            marketView.bookmarkButton.isSelected.toggle()
            let isBookmarked = marketView.bookmarkButton.isSelected
            
            if marketView.bookmarkButton.isSelected {
                postBookmark(placeId: param.placeId)
            } else {
                guard let bookmarkId = storeDetailResponseModel?.bookmarkId else { return }
                deleteBookmark(placeId: param.placeId, bookmarkId: bookmarkId)
            }
            
            NotificationCenter.default.post(
                name: NSNotification.Name("BookmarkUpdated"),
                object: nil,
                userInfo: ["placeId": param.placeId, "isBookmarked": isBookmarked]
            )
        })
        
        
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
    private func getStoreDetail(placeId: Int) {
        StoreRepository.shared.getStoreDetail(placeId: placeId)
            .sinkHandledCompletion(receiveValue: { [weak self] storeDetailResponseModel in
                guard let self = self else { return }
                self.storeDetailResponseModel = storeDetailResponseModel
                initializeView(storeDetailResponseModel: storeDetailResponseModel)
                setStoreToHandlers(storeDetailResponseModel: storeDetailResponseModel)
                getReviewImgs(placeId: param.placeId, page: imageCollectionViewHandler.page)
            })
            .store(in: &cancellable)
    }
    
    private func getReviewImgs(placeId: Int, page: Int) {
        StoreRepository.shared.getReviewImgs(placeId: placeId, page: page)
            .sinkHandledCompletion(receiveValue: { [weak self] reviewImagesResponseModel in
                reviewImagesResponseModel.reviewImageDtoList.forEach({
                    let imageModel = ImageModel(reviewImage: $0)
                    self?.previewCollectionViewHandler.imageModels.append(imageModel)
                    self?.imageCollectionViewHandler.imageModels.append(imageModel)
                })
                self?.imageCollectionViewHandler.isLast = reviewImagesResponseModel.isLast
                self?.imageCollectionViewHandler.page += 1
                if reviewImagesResponseModel.totalElements < 10 {
                    self?.getDaumImgs(placeId: placeId)
                }
                self?.reloadImages()
            })
            .store(in: &cancellable)
    }
    
    private func getDaumImgs(placeId: Int) {
        StoreRepository.shared.getDaumImgs(placeId: placeId)
            .sinkHandledCompletion(receiveValue: { [weak self] daumImageResponseModels in
                daumImageResponseModels.forEach({
                    let imageModel = ImageModel(daumImage: $0)
                    self?.previewCollectionViewHandler.imageModels.append(imageModel)
                    self?.imageCollectionViewHandler.imageModels.append(imageModel)
                })
                self?.reloadImages()
            })
            .store(in: &cancellable)
    }
    
    private func postBookmark(placeId: Int) {
        StoreRepository.shared.postBookmark(placeId: placeId)
            .sinkHandledCompletion(receiveValue: { [weak self] bookmarkResponseModel in
                self?.storeDetailResponseModel?.bookmarkId = bookmarkResponseModel.bookmarkId
            })
            .store(in: &cancellable)
    }
    
    private func deleteBookmark(placeId: Int, bookmarkId: Int) {
        StoreRepository.shared.deleteBookmark(placeId: placeId, bookmarkId: bookmarkId)
            .sinkHandledCompletion(receiveValue: { [weak self] bookmarkResponseModel in
                self?.storeDetailResponseModel?.bookmarkId = nil
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
