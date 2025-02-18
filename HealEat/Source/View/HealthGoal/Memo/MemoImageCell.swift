// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SDWebImage

class MemoImageCell: UICollectionViewCell {
    static let identifier = "MemoImageCell"
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.healeatGray3P5.cgColor
        $0.layer.borderWidth = 1
    }
    private lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "deleteImage")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    var deleteHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViews() {
        contentView.addSubview(imageView)

        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(deleteButton)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.width.height.equalTo(20)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }

    @objc private func deleteTapped() {
        deleteHandler?()
    }
}
