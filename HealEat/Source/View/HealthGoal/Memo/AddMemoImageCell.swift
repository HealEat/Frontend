// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class AddMemoImageCell: UICollectionViewCell {
    static let identifier = "AddMemoImageCell"
    var addImageHandler: (() -> Void)?
    
    private lazy var addButton = UIButton().then {
        $0.setImage(UIImage(named: "addImage"), for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.imageView?.contentMode = .scaleAspectFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViews() {
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        addImageHandler?()
    }
    
    
}

