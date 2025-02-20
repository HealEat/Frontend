// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit
import Kingfisher
import Combine
import CHTCollectionViewWaterfallLayout

class ImageCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    var imageModels: [ImageModel] = []
    var page: Int = 1
    var isLast: Bool = false
    
    var presentImageViewer: (([ImageModel], Int) -> Void)?
    
    var requestImages: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.previewImageView.kf.setImage(with: imageModels[indexPath.row].imageUrl)
        cell.previewImageView.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2
        guard let size = imageModels[indexPath.row].size else {
            return CGSize(width: width, height: width)
        }
        return CGSize(width: width, height: width * size.height / size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentImageViewer?(imageModels, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == imageModels.count - 1 && !isLast else { return }
        requestImages.send(())
    }
}
