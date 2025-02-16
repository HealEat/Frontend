// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class LoadingTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    private func addComponents() {
        contentView.addSubview(baseView)
        baseView.addSubview(mainIndicatorView)
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        })
        mainIndicatorView.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
    }
}
