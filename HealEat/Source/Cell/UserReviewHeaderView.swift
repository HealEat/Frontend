// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

class UserReviewHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .healeatGray3P5
        return view
    }()
    
    lazy var sortButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 10)
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        configuration.attributedTitle = AttributedString("최신 순", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.healeatGray6,
        ]))
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.tintColor = .healeatGray6
        button.menu = UIMenu(title: "정렬 방식을 골라주세요.", identifier: nil, options: .displayInline, children: [
            UIAction(title: "최신 순", handler: { _ in }),
        ])
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .healeatGray3P5
        return view
    }()
    
    private func addComponents() {
        self.addSubview(topSeparatorView)
        self.addSubview(sortButton)
        self.addSubview(bottomSeparatorView)
        setConstraints()
    }
    
    private func setConstraints() {
        topSeparatorView.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        })
        sortButton.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        })
        bottomSeparatorView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        })
    }
}
