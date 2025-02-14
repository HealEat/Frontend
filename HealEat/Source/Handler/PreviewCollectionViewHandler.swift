// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit
import Kingfisher

class PreviewCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageModels: [ImageModel] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.previewImageView.kf.setImage(with: imageModels[indexPath.row].imageUrl)
        cell.previewImageView.layer.cornerRadius = indexPath.row % 3 == 0 ? 12 : 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row % 3 == 0 ? CGSize(width: 120, height: 120) : CGSize(width: 60, height: 56)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
