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
            if false {
                
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserReviewTableViewCell.self), for: indexPath) as? UserReviewTableViewCell else { return UITableViewCell() }
            cell.profileImageView.kf.setImage(with: URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!)
            cell.profileNameLabel.text = "사무엘"
            cell.profilePurposeLabel.text = "과민성 대장 증후군"
            cell.reviewStarsView.star = 3.5
            cell.reviewDateLabel.text = "2024.12.25"
            cell.reviewLabel.text = "배 아프면 꼭 죽집을 찾게 되는데 집 근처에 괜찮은 죽집이 있어서 좋아요. 또 방문하려고요."
            cell.photoStackView.clearSubViews()
            
            if indexPath.row % 2 == 0 {
                cell.addImage(url: URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!)
                cell.addImage(url: URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!)
            }
            return cell
        }
    }
    
    @objc private func onClickReviewMore() {
        pushWriteReviewVC?()
    }
}
