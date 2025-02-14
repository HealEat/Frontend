// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class MarketHomeTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    enum SectionEnum: CaseIterable {
        case info
        case writeReview
        case ratingReview
        case image
    }
    
    var pushWriteReviewVC: (() -> Void)?
    var changePageTo: ((Int) -> Void)?
    
    var imageCollectionViewHandler: ImageCollectionViewHandler = ImageCollectionViewHandler()
    var storeDetailResponseModel: StoreDetailResponseModel?
    
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
            cell.ratingReviewView.initializeView(totalScore: storeDetailResponseModel.isInDBDto.totalScore, totalCount: storeDetailResponseModel.isInDBDto.reviewCount, tasteScore: storeDetailResponseModel.totalStatDto.tastyScore, cleanScore: storeDetailResponseModel.totalStatDto.cleanScore, freshScore: storeDetailResponseModel.totalStatDto.freshScore, nutritionScore: storeDetailResponseModel.totalStatDto.nutrScore)
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
