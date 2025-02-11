// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class FeatureCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var features: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FeatureCollectionViewCell.self), for: indexPath) as? FeatureCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = features[indexPath.row]
        return cell
    }
}
