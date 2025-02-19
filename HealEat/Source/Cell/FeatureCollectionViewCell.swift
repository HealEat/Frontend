// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FeatureCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .healeatGray2
        view.layer.borderColor = UIColor.healeatGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 14
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .healeatGray6
        return label
    }()
    
    private func addComponents() {
        contentView.addSubview(baseView)
        baseView.addSubview(titleLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        titleLabel.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        })
    }
}
