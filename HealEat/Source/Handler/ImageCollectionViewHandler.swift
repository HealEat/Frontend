// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit
import Kingfisher
import CHTCollectionViewWaterfallLayout

struct ImageModel {
    let url: URL
    var size: CGSize?
}

class ImageCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    private var imageModels: [ImageModel]
    
    init(urls: [URL]) {
        self.imageModels = urls.map({ ImageModel(url: $0) })
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.previewImageView.kf.setImage(with: imageModels[indexPath.row].url) { [weak self] result in
            switch result {
            case .success(let value):
                self?.imageModels[indexPath.row].size = value.image.size
            case .failure(let error):
                print(error)
            }
        }
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
        print(indexPath.row)
    }
}
