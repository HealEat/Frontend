// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    var pushWriteReviewVC: (() -> Void)?
    var changePageTo: ((Int) -> Void)?
    
    var storeDetailResponseModel: StoreDetailResponseModel?
    var imageCollectionViewHandler: ImageCollectionViewHandler = ImageCollectionViewHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // imageCollectionView Cell의 너비 재설정
        self.marketHomeView.mainTableView.reloadData()
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.mainTableView.addGestureRecognizer(panGestureRecognizer)
        view.mainTableView.delegate = self
        view.mainTableView.dataSource = self
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        if marketHomeView.mainTableView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
}

extension MarketHomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MarketHomeVC: UITableViewDataSource, UITableViewDelegate {
    enum SectionEnum: CaseIterable {
        case info
        case writeReview
        case ratingReview
        case image
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionEnum.allCases[indexPath.section] {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoreInfoTableViewCell.self), for: indexPath) as? StoreInfoTableViewCell else { return UITableViewCell() }
            guard let storeDetailResponseModel = storeDetailResponseModel else { return cell }
            cell.locationButton.setTitle(storeDetailResponseModel.storeInfoDto.roadAddressName, for: .normal)
            cell.locationButton.menu = UIMenu(identifier: nil, options: .displayInline, children: [
                UIMenu(title: "도로명 주소",identifier: nil, options: .displayInline, children: [UIAction(title: storeDetailResponseModel.storeInfoDto.roadAddressName, handler: { _ in }) ]),
                UIMenu(title: "지번 주소",identifier: nil, options: .displayInline, children: [UIAction(title: storeDetailResponseModel.storeInfoDto.addressName, handler: { _ in }) ]),
            ])
            cell.phoneLabel.text = storeDetailResponseModel.storeInfoDto.phone
            cell.linkButton.addTarget(self, action: #selector(onClickLink), for: .touchUpInside)
            return cell
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
            cell.ratingReviewView.initializeView(totalHealthScore: storeDetailResponseModel.isInDBDto.totalHealthScore, totalCount: storeDetailResponseModel.isInDBDto.reviewCount, tasteScore: storeDetailResponseModel.totalStatDto.tastyScore, cleanScore: storeDetailResponseModel.totalStatDto.cleanScore, freshScore: storeDetailResponseModel.totalStatDto.freshScore, nutritionScore: storeDetailResponseModel.totalStatDto.nutrScore)
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            cell.previewCollectionView.delegate = imageCollectionViewHandler
            cell.previewCollectionView.dataSource = imageCollectionViewHandler
            cell.previewMoreButton.addTarget(self, action: #selector(onClickImageMore), for: .touchUpInside)
            return cell
        }
    }
    
    @objc private func onClickLink() {
        guard let url = storeDetailResponseModel?.storeInfoDto.placeUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func onClickReviewMore() {
        changePageTo?(1)
    }
    
    @objc private func onClickImageMore() {
        changePageTo?(2)
    }
}

