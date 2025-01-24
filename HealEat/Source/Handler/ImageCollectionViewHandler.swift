// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit
import Kingfisher

class ImageCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        let width = (collectionView.bounds.width - 16) / 2
        cell.previewImageView.kf.setImage(with: urls[indexPath.row]) { result in
            switch result {
            case .success(let value):
                print("width: \(width), height: \(width * value.image.size.height / value.image.size.width)")
                cell.updateSize(width: width, height: width * value.image.size.height / value.image.size.width)
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
}
