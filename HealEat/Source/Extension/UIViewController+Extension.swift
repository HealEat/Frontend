// Copyright © 2025 HealEat. All rights reserved.

import UIKit

extension UIViewController {
    private static let loadingIndicatorTag = 999 // 고유 태그

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .last(where: { $0.isKeyWindow }) else { return }

            if window.subviews.contains(where: { $0.tag == UIViewController.loadingIndicatorTag }) { return }

            let backgroundView = UIView(frame: window.bounds)
            backgroundView.tag = UIViewController.loadingIndicatorTag
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            backgroundView.isUserInteractionEnabled = true
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = backgroundView.center
            indicator.startAnimating()

            backgroundView.addSubview(indicator)
            window.addSubview(backgroundView)
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .last(where: { $0.isKeyWindow }) else { return }

            window.subviews.filter { $0.tag == UIViewController.loadingIndicatorTag }.forEach { $0.removeFromSuperview() }
        }
    }
}

