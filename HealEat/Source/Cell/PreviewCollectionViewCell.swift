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
    
    lazy var xButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")?.resize(to: CGSize(width: 8, height: 8))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        configuration.baseForegroundColor = .white
        
        button.configuration = configuration
        button.layer.cornerRadius = 6
        button.tintColor = .white
        button.backgroundColor = .healeatBlack65P
        button.isHidden = true
        return button
    }()
    
    private func addComponents() {
        contentView.addSubview(previewImageView)
        contentView.addSubview(xButton)
        setConstraints()
    }
    
    private func setConstraints() {
        previewImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        xButton.snp.makeConstraints({ make in
            make.top.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(12)
        })
    }
}
