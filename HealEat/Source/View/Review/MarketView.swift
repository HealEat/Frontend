//
//  MarketView.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.15.
//

import UIKit
import SnapKit

class MarketView: UIView {
    
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
    
    lazy var topTabBar: TabBarSegmentedControl = {
        let tabBarSegmentedControl = TabBarSegmentedControl(menus: [
            "홈",
            "메뉴",
            "리뷰",
            "사진",
        ])
        return tabBarSegmentedControl
    }()
    
    
    private func addComponents() {
        self.addSubview(topTabBar)
        setConstraints()
    }
    private func setConstraints() {
        topTabBar.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    }
}
