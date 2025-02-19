// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Combine

enum SortEnum: String, CaseIterable {
    case latest = "LATEST"
    case desc = "DESC"
    case asc = "ASC"
    
    var title: String {
        switch self {
        case .latest:
            return "최신 순"
        case .desc:
            return "별점 높은 순"
        case .asc:
            return "별점 낮은 순"
        }
    }
}

enum FilterEnum: String {
    case sick = "SICK"
    case veget = "VEGET"
    case diet = "DIET"
}

class MarketReviewVC: UIViewController {
    
    struct Param {
        let placeId: Int
    }
    var param: Param!
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    var storeDetailResponseModel: StoreDetailResponseModel?
    var reviewModels: [ReviewsResponseModel.ReviewList] = []
    
    private var page: Int = 1
    private var isLast: Bool = false
    
    private var requestReviews: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketReviewView
        getReviews(reviewsRequest: ReviewsRequest(
            placeId: param.placeId,
            page: page,
            sortBy: UserDefaultsManager.shared.reviewSort,
            filters: UserDefaultsManager.shared.reviewFilters
        ))
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }
    
    private func bind() {
        requestReviews
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                getReviews(reviewsRequest: ReviewsRequest(
                    placeId: param.placeId,
                    page: page,
                    sortBy: UserDefaultsManager.shared.reviewSort,
                    filters: UserDefaultsManager.shared.reviewFilters
                ))
            })
            .store(in: &cancellable)
    }
    
    lazy var marketReviewView: MarketReviewView = {
        let view = MarketReviewView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.reviewTableView.addGestureRecognizer(panGestureRecognizer)
        view.reviewTableView.delegate = self
        view.reviewTableView.dataSource = self
        
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketReviewView.reviewTableView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
    
    private func getReviews(reviewsRequest: ReviewsRequest) {
        StoreRepository.shared.getReviews(reviewsRequest: reviewsRequest)
            .sinkHandledCompletion(receiveValue: { [weak self] reviewsResponseModel in
                self?.reviewModels.append(contentsOf: reviewsResponseModel.reviewList)
                self?.isLast = reviewsResponseModel.isLast
                self?.page += 1
                self?.marketReviewView.reviewTableView.reloadData()
            })
            .store(in: &cancellable)
    }
    
    private func reloadData() {
        page = 1
        reviewModels = []
        getReviews(reviewsRequest: ReviewsRequest(
            placeId: param.placeId,
            page: page,
            sortBy: UserDefaultsManager.shared.reviewSort,
            filters: UserDefaultsManager.shared.reviewFilters
        ))
    }
}

extension MarketReviewVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MarketReviewVC: UITableViewDataSource, UITableViewDelegate {
    private enum SectionEnum: Int, CaseIterable {
        case writeReview = 0
        case ratingReview
        case userReview
        case loading
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch SectionEnum.allCases[section] {
        case .writeReview:
            return nil
        case .ratingReview:
            return nil
        case .userReview:
            let headerView = UserReviewHeaderView()
            headerView.sortButton.configuration?.attributedTitle = AttributedString(UserDefaultsManager.shared.reviewSort.title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.healeatGray6,
            ]))
            headerView.sortButton.menu = UIMenu(identifier: nil, options: .displayInline, children:
                SortEnum.allCases.map({ [weak self] sortEnum in
                    UIAction(title: sortEnum.title, image: UserDefaultsManager.shared.reviewSort == sortEnum ? UIImage(resource: .check) : nil, handler: { _ in
                        UserDefaultsManager.shared.reviewSort = sortEnum
                        self?.reloadData()
                    })
                })
            )
            headerView.sickButton.configuration?.attributedTitle = AttributedString("질병관리", attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UserDefaultsManager.shared.reviewFilters.contains(.sick) ? UIColor.healeatGreen1 : UIColor.healeatGray6,
            ]))
            headerView.vegetButton.configuration?.attributedTitle = AttributedString("베지테리언", attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UserDefaultsManager.shared.reviewFilters.contains(.veget) ? UIColor.healeatGreen1 : UIColor.healeatGray6,
            ]))
            headerView.dietButton.configuration?.attributedTitle = AttributedString("다이어트", attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UserDefaultsManager.shared.reviewFilters.contains(.diet) ? UIColor.healeatGreen1 : UIColor.healeatGray6,
            ]))
            headerView.sickButton.configuration?.image = UserDefaultsManager.shared.reviewFilters.contains(.sick) ? UIImage(resource: .check) : UIImage(resource: .nocheck)
            headerView.vegetButton.configuration?.image = UserDefaultsManager.shared.reviewFilters.contains(.veget) ? UIImage(resource: .check) : UIImage(resource: .nocheck)
            headerView.dietButton.configuration?.image = UserDefaultsManager.shared.reviewFilters.contains(.diet) ? UIImage(resource: .check) : UIImage(resource: .nocheck)
            headerView.sickButton.addTarget(self, action: #selector(onClickSick), for: .touchUpInside)
            headerView.vegetButton.addTarget(self, action: #selector(onClickVeget), for: .touchUpInside)
            headerView.dietButton.addTarget(self, action: #selector(onClickDiet), for: .touchUpInside)
            return headerView
        case .loading:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch SectionEnum.allCases[section] {
        case .writeReview:
            return 0
        case .ratingReview:
            return 0
        case .userReview:
            return 32
        case .loading:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionEnum.allCases[section] {
        case .writeReview:
            return 1
        case .ratingReview:
            return 1
        case .userReview:
            return max(1, reviewModels.count)
        case .loading:
            return isLast ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionEnum.allCases[indexPath.section] {
        case .writeReview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WriteReviewTableViewCell.self), for: indexPath) as? WriteReviewTableViewCell else { return UITableViewCell() }
            guard let storeDetailResponseModel = storeDetailResponseModel else { return cell }
            cell.reviewTitleLabel.text = "'\(storeDetailResponseModel.storeInfoDto.placeName)'의\n건강 평점을 남겨주세요!"
            cell.reviewMoreButton.addTarget(self, action: #selector(onClickReviewMore), for: .touchUpInside)
            return cell
        case .ratingReview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RatingReviewTableViewCell.self), for: indexPath) as? RatingReviewTableViewCell else { return UITableViewCell() }
            guard let storeDetailResponseModel = storeDetailResponseModel else { return cell }
            cell.ratingReviewView.isUserInteractionEnabled = false
            cell.ratingReviewView.initializeView(
                totalHealthScore: storeDetailResponseModel.isInDBDto.totalHealthScore,
                totalCount: storeDetailResponseModel.isInDBDto.reviewCount,
                tasteScore: storeDetailResponseModel.totalStatDto.tastyScore,
                cleanScore: storeDetailResponseModel.totalStatDto.cleanScore,
                freshScore: storeDetailResponseModel.totalStatDto.freshScore,
                nutritionScore: storeDetailResponseModel.totalStatDto.nutrScore
            )
            return cell
        case .userReview:
            if reviewModels.count == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoReviewTableViewCell.self), for: indexPath) as? NoReviewTableViewCell else { return UITableViewCell() }
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserReviewTableViewCell.self), for: indexPath) as? UserReviewTableViewCell else { return UITableViewCell() }
            cell.profileImageView.kf.setImage(with: reviewModels[indexPath.row].reviewerInfo.profileImageUrl, placeholder: UIImage(resource: .defaultProfile))
            cell.profileNameLabel.text = reviewModels[indexPath.row].reviewerInfo.name
            cell.profilePurposeLabel.text = reviewModels[indexPath.row].reviewerInfo.currentPurposes.joined(separator: ", ")
            cell.profilePurposeButton.menu = UIMenu(identifier: nil, options: .displayInline, children:
                reviewModels[indexPath.row].reviewerInfo.currentPurposes.map({ UIAction(title: $0, handler: { _ in }) })
            )
            cell.reviewStarsView.star = reviewModels[indexPath.row].totalScore
            cell.reviewDateLabel.text = reviewModels[indexPath.row].createdAt.toStringYYYYMMDD
            cell.reviewLabel.text = reviewModels[indexPath.row].body
            cell.updateCollectionViewVisibility(isVisible: !reviewModels[indexPath.row].imageUrls.isEmpty)
            cell.handler.images = reviewModels[indexPath.row].imageUrls
            cell.imageCollectionView.reloadData()
            return cell
        case .loading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingTableViewCell.self), for: indexPath) as? LoadingTableViewCell else { return UITableViewCell() }
            cell.mainIndicatorView.startAnimating()
            return cell
        }
    }
    
    @objc private func onClickReviewMore() {
        guard let storeDetailResponseModel = storeDetailResponseModel else { return }
        let viewController = WriteReviewVC()
        viewController.param = WriteReviewVC.Param(storeDetailResponseModel: storeDetailResponseModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func onClickFilter(filterEnum: FilterEnum) {
        var filters = UserDefaultsManager.shared.reviewFilters
        if filters.contains(filterEnum) {
            filters.remove(filterEnum)
        } else {
            filters.insert(filterEnum)
        }
        UserDefaultsManager.shared.reviewFilters = filters
        reloadData()
    }
    @objc private func onClickSick() {
        onClickFilter(filterEnum: .sick)
    }
    @objc private func onClickVeget() {
        onClickFilter(filterEnum: .veget)
    }
    @objc private func onClickDiet() {
        onClickFilter(filterEnum: .diet)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let isLoadingVisible = marketReviewView.reviewTableView.indexPathsForVisibleRows?.contains(where: { SectionEnum(rawValue: $0.section) == .loading }),
              isLoadingVisible && !isLast else { return }
        requestReviews.send(())
    }
}
