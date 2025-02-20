// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ImageSelectionCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var maxImages = 5
    var images: [UIImage] = [] {
        didSet {
            reloadData()
        }
    }
    
    var addImageHandler: (() -> Void)?
    var deleteImageHandler: ((Int) -> Void)?
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5  // 아이템 간격
        layout.minimumLineSpacing = 5       // 줄 간격
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(MemoImageCell.self, forCellWithReuseIdentifier: MemoImageCell.identifier)
        self.register(AddMemoImageCell.self, forCellWithReuseIdentifier: AddMemoImageCell.identifier)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /// ✅ VC에서 호출할 수 있도록 images를 업데이트하는 메서드 추가!
    func updateImages(_ newImages: [UIImage]) {
        self.images = newImages
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < maxImages ? images.count + 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < images.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoImageCell.identifier, for: indexPath) as? MemoImageCell else { return UICollectionViewCell() }
            cell.configure(with: images[indexPath.item])
            cell.deleteHandler = { [weak self] in
                self?.deleteImageHandler?(indexPath.item)
            }
            return cell
        } else if indexPath.item == images.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMemoImageCell.identifier, for: indexPath) as? AddMemoImageCell else { return UICollectionViewCell() }
            cell.addImageHandler = { [weak self] in
                self?.addImageHandler?()
            }
            return cell
        } else {
            // 빈 셀을 만들어서 자리 유지
            let cell = UICollectionViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }

    // 한 줄에 3개씩 배치
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let adjustedWidth = (totalWidth - 10) / 3 
        return CGSize(width: adjustedWidth, height: adjustedWidth)
    }
}
