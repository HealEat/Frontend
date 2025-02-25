// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ImageViewerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .healeatBlack65P
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var fakeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .previous), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .next), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var profileView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .healeatGray1
        return label
    }()
    
    lazy var purposeButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = .zero
        configuration.contentInsets = .zero
        
        button.configuration = configuration
        return button
    }()
    
    lazy var xButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")?.resize(to: CGSize(width: 16, height: 16))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        configuration.baseForegroundColor = .white
        
        button.configuration = configuration
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.backgroundColor = .healeatBlack65P
        button.isHidden = true
        return button
    }()
    
    private func addComponents() {
        self.addSubview(mainImageView)
        self.addSubview(profileView)
        self.addSubview(fakeButton)
        self.addSubview(previousButton)
        self.addSubview(nextButton)
        self.addSubview(xButton)
        
        profileView.addSubview(profileImageView)
        profileView.addSubview(nameLabel)
        profileView.addSubview(purposeButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        mainImageView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0) // For UpdateConstraints
        })
        fakeButton.snp.makeConstraints({ make in
            make.edges.equalTo(mainImageView)
        })
        previousButton.snp.makeConstraints({ make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        })
        nextButton.snp.makeConstraints({ make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        profileView.snp.makeConstraints({ make in
            make.top.equalTo(mainImageView.snp.bottom).offset(13).priority(500)
            make.leading.trailing.equalToSuperview().inset(17)
            make.bottom.lessThanOrEqualToSuperview().inset(32)
        })
        profileImageView.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        })
        nameLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        })
        purposeButton.snp.makeConstraints({ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        })
        xButton.snp.makeConstraints({ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        })
    }
}
