// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class DetailRatingHorizontalCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var detailRatings: [(String, Float, Int)]
    
    init(detailRatings: [(String, Float, Int)]) {
        self.detailRatings = detailRatings
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailRatings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailRatingHorizontalCollectionViewCell.self), for: indexPath) as? DetailRatingHorizontalCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = detailRatings[indexPath.row].0
        cell.scoreLabel.text = String(format: "%.1f", detailRatings[indexPath.row].1)
        return cell
    }
    
    
}
