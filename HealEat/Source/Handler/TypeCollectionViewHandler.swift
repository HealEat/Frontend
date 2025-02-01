// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class TypeCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let types: [String]
    
    init(types: [String]) {
        self.types = types
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TypeCollectionViewCell.self), for: indexPath) as? TypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = types[indexPath.row]
        return cell
    }
}
