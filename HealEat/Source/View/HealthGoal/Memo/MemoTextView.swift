// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MemoTextView: UITextView {

    var placeholder: String? {
        didSet { setNeedsDisplay() }
    }

    var placeholderColor: UIColor = .lightGray {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard text.isEmpty, let placeholder = placeholder else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 13, weight: .light),
            .foregroundColor: placeholderColor,
            .paragraphStyle: paragraphStyle
        ]

        let placeholderRect = CGRect(x: 0, y: 0, width: rect.width - 10, height: rect.height - 16)
        placeholder.draw(in: placeholderRect, withAttributes: attributes)
    }

    override var text: String! {
        didSet { setNeedsDisplay() }
    }
}
