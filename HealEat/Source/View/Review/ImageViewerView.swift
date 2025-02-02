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
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .next), for: .normal)
        return button
    }()
    
    private func addComponents() {
        self.addSubview(mainImageView)
        self.addSubview(fakeButton)
        self.addSubview(previousButton)
        self.addSubview(nextButton)
        setConstraints()
    }
    
    private func setConstraints() {
        mainImageView.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
    }
}
