// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ReviewBar: UIView {
    
    private var process: CGFloat = 0
    
    private let myBackgroundColor: UIColor = .systemBackground
    private let foregroundColor: UIColor = UIColor(red: 90/255, green: 237/255, blue: 76/255, alpha: 1)
    
    var valueChanged: ((CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawProcess(process: CGFloat) {
        self.process = max(0, min(process, 1))
        setNeedsDisplay()
        valueChanged?(self.process)
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let backgroundRect = CGRect(x: 0, y: 0, width: width, height: height)
        let backgroundPath = UIBezierPath(rect: backgroundRect)
        myBackgroundColor.setFill()
        backgroundPath.fill()
        
        let processRect = CGRect(x: 0, y: 0, width: process*width, height: height)
        let processPath = UIBezierPath(rect: processRect)
        foregroundColor.setFill()
        processPath.fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        drawProcess(process: point.x / self.frame.width)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        drawProcess(process: point.x / self.frame.width)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        drawProcess(process: point.x / self.frame.width)
    }
}
