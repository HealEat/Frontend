// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import CHTCollectionViewWaterfallLayout

class ImageTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var previewCollectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 16
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        
        return collectionView
    }()
    
    lazy var previewMoreButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        configuration.background.backgroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("사진 더보기", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.healeatGray5,
        ]))
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.layer.borderColor = UIColor.healeatGray3.cgColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    private func addComponents() {
        contentView.addSubview(previewCollectionView)
        contentView.addSubview(previewMoreButton)
        setConstraints()
    }
    
    private func setConstraints() {
        previewCollectionView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(390)
        })
        previewMoreButton.snp.makeConstraints({ make in
            make.top.equalTo(previewCollectionView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        })
    }
}
