// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ReviewBar: UIView {
    
    private var process: CGFloat = 0
    
    private let field: ReviewFieldEnum
    
    private let baseColor: UIColor = .healeatLightGreen3
    private let accentColor: UIColor = .healeatGreen2
    private let borderColor: UIColor = .healeatGreen1
    private var expressionColor: UIColor = .healeatGreen1
    
    private var expression: String {
        get {
            switch field {
            case .taste:
                return "맛있어요"
            case .clean:
                return "깨끗해요"
            case .fresh:
                return "신선해요"
            case .nutrition:
                return "영양성분이 고르게 갖춰져 있어요"
            }
        }
    }
    
    var valueChanged: ((CGFloat) -> Void)?
    
    init(field: ReviewFieldEnum) {
        self.field = field
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
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
        let defaultValue: CGFloat = 14
        
        let width = rect.width - defaultValue
        let height = rect.height
        
        let backgroundRect = CGRect(x: 0, y: 0, width: defaultValue + width, height: height)
        let backgroundPath = UIBezierPath(rect: backgroundRect)
        baseColor.setFill()
        backgroundPath.fill()
        
        let processRect = CGRect(x: -width + process*width, y: 0, width: defaultValue + width, height: height)
        let processPath = UIBezierPath(roundedRect: processRect, cornerRadius: 12)
        accentColor.setFill()
        processPath.fill()
        
        borderColor.setStroke()
        processPath.lineWidth = 0.5
        processPath.stroke()
        
        let arrow = UIBezierPath()
        let startPoint = CGPoint(x: defaultValue + process*width - 8, y: rect.midY - 4)
        let middlePoint = CGPoint(x: defaultValue + process*width - 5, y: rect.midY)
        let endPoint = CGPoint(x: defaultValue + process*width - 8, y: rect.midY + 4)
        
        arrow.move(to: startPoint)
        arrow.addLine(to: middlePoint)
        arrow.addLine(to: endPoint)
        
        borderColor.setStroke()
        arrow.lineWidth = 1
        arrow.stroke()
        
        let expressionStyle = NSMutableParagraphStyle()
        expressionStyle.alignment = .right
        let whiteAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
            .paragraphStyle: expressionStyle,
            .foregroundColor: expressionColor.withAlphaComponent(process)
        ]
        let expressionSize = expression.size(withAttributes: whiteAttributes)
        
        let expressionRect = CGRect(x: defaultValue + process*width - 12 - expressionSize.width, y: (height - expressionSize.height) / 2, width: expressionSize.width, height: expressionSize.height)
        expression.draw(in: expressionRect, withAttributes: whiteAttributes)
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
