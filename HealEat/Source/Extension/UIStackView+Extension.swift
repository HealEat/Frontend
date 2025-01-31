// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

extension UIStackView {
    func clearSubViews() {
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
