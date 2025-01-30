// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        view.layer.cornerRadius = 9
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        label.textColor = UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
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
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        })
    }
}
