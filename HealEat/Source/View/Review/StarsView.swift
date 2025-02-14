// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class StarsView: UIView {
    
    private let accentColor: UIColor
    private let baseColor: UIColor
    
    private let starViews: [StarBackgroundView]
    
    var star: Float {
        didSet {
            for i in 0..<5 {
                starViews[i].fill = max(0, min(star-Float(i), 1))
            }
        }
    }
    
    init(accentColor: UIColor, baseColor: UIColor) {
        self.accentColor = accentColor
        self.baseColor = baseColor
        self.starViews = [
            StarBackgroundView(accentColor: accentColor, baseColor: baseColor, fill: 0),
            StarBackgroundView(accentColor: accentColor, baseColor: baseColor, fill: 0),
            StarBackgroundView(accentColor: accentColor, baseColor: baseColor, fill: 0),
            StarBackgroundView(accentColor: accentColor, baseColor: baseColor, fill: 0),
            StarBackgroundView(accentColor: accentColor, baseColor: baseColor, fill: 0),
        ]
        star = 0
        
        super.init(frame: .zero)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onClickStar(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let star = gestureRecognizer.view?.tag else { return }
        self.star = Float(star)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        for (i, starView) in starViews.enumerated() {
            starView.maskImageView.frame = starView.bounds
            starView.mask = starView.maskImageView
            starView.tag = i + 1
            starView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickStar(_:))))
        }
    }
    
    lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        starViews.forEach({ starView in
            stackView.addArrangedSubview(starView)
        })
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

class StarBackgroundView: UIView {
    
    private let accentColor: UIColor
    private let baseColor: UIColor
    
    var fill: Float {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(accentColor: UIColor, baseColor: UIColor, fill: Float) {
        self.accentColor = accentColor
        self.baseColor = baseColor
        self.fill = max(0, min(fill, 1))
        super.init(frame: .zero)
        self.snp.makeConstraints({ make in
            make.width.equalTo(self.snp.height)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var maskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .star)
        imageView.frame = bounds
        
        return imageView
    }()
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let backgroundRect = CGRect(x: 0, y: 0, width: width, height: height)
        let backgroundPath = UIBezierPath(rect: backgroundRect)
        baseColor.setFill()
        backgroundPath.fill()
        
        let processRect = CGRect(x: 0, y: 0, width: CGFloat(fill)*width, height: height)
        let processPath = UIBezierPath(rect: processRect)
        accentColor.setFill()
        processPath.fill()
    }
}
