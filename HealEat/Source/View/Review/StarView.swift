// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class StarView: UIView {
    
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
        imageView.image = UIImage(systemName: "star.fill")
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
