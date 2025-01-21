// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private func addComponents() {
        self.addSubview(previewImageView)
        setConstraints()
    }
    
    private func setConstraints() {
        previewImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
