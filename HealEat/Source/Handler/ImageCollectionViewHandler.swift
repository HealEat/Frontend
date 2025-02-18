// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit
import Kingfisher
import Combine
import CHTCollectionViewWaterfallLayout

class ImageCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    private enum SectionEnum: Int, CaseIterable {
        case image = 0
        case loading
    }
    
    var imageModels: [ImageModel] = []
    var page: Int = 1
    var isLast: Bool = false
    
    var presentImageViewer: (([ImageModel], Int) -> Void)?
    
    var requestImages: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: LoadingHeaderView.self), for: indexPath) as? LoadingHeaderView,
           kind == UICollectionView.elementKindSectionHeader {
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        switch SectionEnum.allCases[section] {
        case .image:
            return 0
        case .loading:
            return isLast ? 0 : 50
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionEnum.allCases[section] {
        case .image:
            return imageModels.count
        case .loading:
            return 0
        }
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
        switch SectionEnum.allCases[indexPath.section] {
        case .image:
            self.presentImageViewer?(imageModels, indexPath.row)
        case .loading:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader).contains(where: { SectionEnum(rawValue: $0.section) == .loading })
              && !isLast else { return }
        requestImages.send(())
    }
}
