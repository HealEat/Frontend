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
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 11)
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        configuration.titleAlignment = .center
        
        button.configuration = configuration
        button.tintColor = .healeatGray6
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var sickButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.contentInsets = .zero
        
        button.configuration = configuration
//        button.tintColor = .healeatGray6
        
        return button
    }()
    
    lazy var vegetButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.contentInsets = .zero
        
        button.configuration = configuration
//        button.tintColor = .healeatGray6
        
        return button
    }()
    
    lazy var dietButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.contentInsets = .zero
        
        button.configuration = configuration
//        button.tintColor = .healeatGray6
        
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
        self.addSubview(filterStackView)
        
        filterStackView.addArrangedSubview(sickButton)
        filterStackView.addArrangedSubview(vegetButton)
        filterStackView.addArrangedSubview(dietButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        topSeparatorView.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        })
        sortButton.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        })
        bottomSeparatorView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        })
        filterStackView.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        })
    }
}
