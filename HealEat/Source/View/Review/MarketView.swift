// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class MarketView: UIView {
    
    var pageViewControllers: [UIViewController] = []
    
    var expanded: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var navigationView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var expandableAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var topTabBar: TabBarSegmentedControl = {
        let tabBarSegmentedControl = TabBarSegmentedControl(menus: [
            "홈",
            "사진",
            "리뷰",
        ])
        return tabBarSegmentedControl
    }()
    
    lazy var menuPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let firstViewController = pageViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        return pageViewController
    }()
    
    
    private func addComponents() {
        self.addSubview(navigationView)
        navigationView.addSubview(navigationBackButton)
        self.addSubview(expandableAreaView)
        self.addSubview(topTabBar)
        self.addSubview(menuPageViewController.view)
        setConstraints()
    }
    private func setConstraints() {
        navigationView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        })
        navigationBackButton.snp.makeConstraints({ make in
            make.width.height.equalTo(32)
            make.leading.top.bottom.equalToSuperview()
        })
        expandableAreaView.snp.makeConstraints({ make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(GlobalConst.marketScrolledAreaHeightConstraint)
        })
        topTabBar.snp.makeConstraints({ make in
            make.top.equalTo(expandableAreaView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        })
        menuPageViewController.view.snp.makeConstraints({ make in
            make.top.equalTo(topTabBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        })
    }
    
    func updateExpandableAreaView(height: CGFloat) {
        let correctedHeight = min(max(0, height), GlobalConst.marketScrolledAreaHeightConstraint)
        
        expandableAreaView.snp.remakeConstraints({ make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(correctedHeight)
        })
    }
}
