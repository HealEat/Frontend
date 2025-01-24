// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketHomeVC: UIViewController {
    
    var onGesture: ((UIPanGestureRecognizer) -> Void)?
    
    private var imageCollectionViewHandler = ImageCollectionViewHandler(urls: [
        URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
        URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = marketHomeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.marketHomeView.imageCollectionView.reloadData()
    }
    
    lazy var marketHomeView: MarketHomeView = {
        let view = MarketHomeView()
        view.mainScrollView.isUserInteractionEnabled = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer: )))
        panGestureRecognizer.delegate = self
        view.mainScrollView.addGestureRecognizer(panGestureRecognizer)
        view.imageCollectionView.dataSource = imageCollectionViewHandler
        view.imageCollectionView.delegate = imageCollectionViewHandler
        return view
    }()
    
    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        print(marketHomeView.mainScrollView.contentOffset.y)
        if marketHomeView.mainScrollView.contentOffset.y > 0 {
            recognizer.state = .ended
        }
        onGesture?(recognizer)
    }
    
}

extension MarketHomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
