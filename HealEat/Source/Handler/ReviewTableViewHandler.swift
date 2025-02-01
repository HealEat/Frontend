// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

enum ReviewSectionEnum: CaseIterable {
    case writeReview
    case ratingReview
    case userReview
}

// TODO: Hosung.Kim API 연결 이후 수정할 것
class ReviewTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var pushWriteReviewVC: (() -> Void)?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReviewSectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch ReviewSectionEnum.allCases[section] {
        case .writeReview:
            return nil
        case .ratingReview:
            return nil
        case .userReview:
            return UserReviewHeaderView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch ReviewSectionEnum.allCases[section] {
        case .writeReview:
            return 0
        case .ratingReview:
            return 0
        case .userReview:
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ReviewSectionEnum.allCases[section] {
        case .writeReview:
            return 1
        case .ratingReview:
            return 1
        case .userReview:
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ReviewSectionEnum.allCases[indexPath.section] {
        case .writeReview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WriteReviewTableViewCell.self), for: indexPath) as? WriteReviewTableViewCell else { return UITableViewCell() }
            cell.reviewTitleLabel.text = "'본죽&비빔밥cafe 홍대점'의\n건강 평점을 남겨주세요!"
            cell.reviewMoreButton.addTarget(self, action: #selector(onClickReviewMore), for: .touchUpInside)
            return cell
        case .ratingReview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RatingReviewTableViewCell.self), for: indexPath) as? RatingReviewTableViewCell else { return UITableViewCell() }
            cell.ratingReviewView.isUserInteractionEnabled = false
            cell.ratingReviewView.reviewStarsView.star = 3.6
            cell.ratingReviewView.reviewLabel.text = "3.6 (23)"
            cell.ratingReviewView.tasteReviewView.reviewBar.drawProcess(process: 1.6 / CGFloat(GlobalConst.maxRating))
            cell.ratingReviewView.cleanReviewView.reviewBar.drawProcess(process: 4.2 / CGFloat(GlobalConst.maxRating))
            cell.ratingReviewView.freshReviewView.reviewBar.drawProcess(process: 3.5 / CGFloat(GlobalConst.maxRating))
            cell.ratingReviewView.nutritionReviewView.reviewBar.drawProcess(process: 2.6 / CGFloat(GlobalConst.maxRating))
            return cell
        case .userReview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserReviewTableViewCell.self), for: indexPath) as? UserReviewTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
    
    @objc private func onClickReviewMore() {
        pushWriteReviewVC?()
    }
}
