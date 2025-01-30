























































































































































































//
//  ViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.08.
//

import UIKit

class BaseVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        appearance()
    }
    
    func setTabBar() {
        //TODO:여기서 월드 부분 뭐시기 컨트롤러? 뭐 그런걸로 해야 스유랑 연결됨
        let vc1 = UINavigationController(rootViewController: HomeVC())
        vc1.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home"), tag: 1)
        let vc2 = UINavigationController(rootViewController: SearchVC())
        vc2.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search"), tag: 2)
        let vc3 = UINavigationController(rootViewController: HealthGoalVC())
        vc3.tabBarItem = UITabBarItem(title: "건강목표", image: UIImage(named: "Goals"), tag: 3)
        let vc4 = UINavigationController(rootViewController: MyPageVC())
        vc4.tabBarItem = UITabBarItem(title: "MY", image: UIImage(named: "My"), tag: 4)
        self.viewControllers = [vc1, vc2, vc3, vc4]
    }
    
    func appearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        // 아이콘 기본 색상 설정
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#6A6A6A")
        
        self.tabBar.standardAppearance = tabBarAppearance
        
        self.tabBar.layer.masksToBounds = false
        self.tabBar.tintColor = UIColor(hex: "#009459")
        self.tabBar.backgroundColor = .white
        
        // 그림자 설정
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.tabBar.layer.shadowRadius = 10
        
        // 탭바 아이템 위치 조정
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 55
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 100
        tabFrame.origin.y = view.frame.size.height - 100
        tabBar.frame = tabFrame
    }



}
