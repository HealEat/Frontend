// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class DetailRatingCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var detailRatings: [(String, Float, Int)] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailRatings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailRatingCollectionViewCell.self), for: indexPath) as? DetailRatingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = detailRatings[indexPath.row].0
        cell.ratingLabel.text = detailRatings[indexPath.row].2 == 0 ? "리뷰 없음" : detailRatings[indexPath.row].1.oneDecimalString
        cell.ratingCountLabel.text = "(\(detailRatings[indexPath.row].2))"
        return cell
    }
    
    
}
