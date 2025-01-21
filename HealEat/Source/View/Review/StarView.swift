// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class StarView: UIView {
    
    private let accentColor: UIColor
    private let baseColor: UIColor
    
    var star: Int {
        didSet {
            for i in 0..<star {
                starStackView.subviews[i].tintColor = accentColor
            }
            for i in star..<5 {
                starStackView.subviews[i].tintColor = baseColor
            }
        }
    }
    
    init(accentColor: UIColor, baseColor: UIColor) {
        self.accentColor = accentColor
        self.baseColor = baseColor
        star = 0
        super.init(frame: .zero)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        for i in 0..<5 {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "star.fill")
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()
    
    private func addComponents() {
        self.addSubview(starStackView)
        setConstraints()
    }
    
    private func setConstraints() {
        starStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
