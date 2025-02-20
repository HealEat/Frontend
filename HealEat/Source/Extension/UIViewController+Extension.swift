// Copyright © 2025 HealEat. All rights reserved.

import UIKit

extension UIViewController {
    private static let loadingIndicatorTag = 999 // 고유 태그

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.getMostTopViewController() else { return }

            if topVC.view.viewWithTag(UIViewController.loadingIndicatorTag) != nil { return }

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.tag = UIViewController.loadingIndicatorTag
            indicator.center = topVC.view.center
            indicator.hidesWhenStopped = true
            indicator.startAnimating()

            let backgroundView = UIView(frame: topVC.view.bounds)
            backgroundView.tag = UIViewController.loadingIndicatorTag + 1
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            backgroundView.isUserInteractionEnabled = true
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            topVC.view.addSubview(backgroundView)
            topVC.view.addSubview(indicator)

        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.getMostTopViewController() else { return }

            topVC.view.viewWithTag(UIViewController.loadingIndicatorTag)?.removeFromSuperview()
            topVC.view.viewWithTag(UIViewController.loadingIndicatorTag + 1)?.removeFromSuperview()
        }
    }
}


extension UIApplication {
    /// 현재 최상위 ViewController 찾기
    static func getMostTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
                                            .first) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getMostTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            return getMostTopViewController(base: tab.selectedViewController)
        } else if let presented = base?.presentedViewController {
            return getMostTopViewController(base: presented)
        }
        return base
    }
}
