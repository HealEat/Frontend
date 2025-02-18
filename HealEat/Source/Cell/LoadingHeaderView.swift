// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class LoadingHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
        indicatorView.color = .healeatBlack
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    private func addComponents() {
        self.addSubview(baseView)
        baseView.addSubview(mainIndicatorView)
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        mainIndicatorView.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
    }
}
