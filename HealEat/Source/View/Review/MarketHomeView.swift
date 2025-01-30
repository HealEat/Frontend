// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bouncesVertically = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private func addComponents() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        setConstraints()
    }
    
    private func setConstraints() {
        mainScrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(3000)
        })
    }
}
