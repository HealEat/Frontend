// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class WriteReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topReviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var topStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        return starsView
    }()
    
    private func addComponents() {
        self.addSubview(topReviewView)
        
        topReviewView.addSubview(topStackView)
        
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(topStarsView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        topReviewView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        topStackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        })
        topStarsView.snp.makeConstraints({ make in
            make.height.equalTo(13)
        })
    }
}
