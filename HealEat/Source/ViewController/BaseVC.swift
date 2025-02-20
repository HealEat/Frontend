// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class BaseVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        appearance()
    }
    
    func setTabBar() {
        let vc1 = UINavigationController(rootViewController: HomeVC())
        //let vc1 = UINavigationController(rootViewController: SearchVC())
        vc1.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home")?.withRenderingMode(.alwaysTemplate), tag: 1)
        let vc2 = UINavigationController(rootViewController: SearchVC())
        vc2.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate), tag: 2)
        let vc3 = UINavigationController(rootViewController: HealthGoalVC())
        vc3.tabBarItem = UITabBarItem(title: "건강목표", image: UIImage(named: "Goals")?.withRenderingMode(.alwaysTemplate), tag: 3)
        let vc4 = UINavigationController(rootViewController: MyPageVC())
        vc4.tabBarItem = UITabBarItem(title: "MY", image: UIImage(named: "My")?.withRenderingMode(.alwaysTemplate), tag: 4)
        self.viewControllers = [vc1, vc2, vc3, vc4]
    }
    
    func appearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        // 아이콘 기본 색상 설정
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.healeatGray4P5
        
        self.tabBar.standardAppearance = tabBarAppearance
        
        self.tabBar.layer.masksToBounds = false
        self.tabBar.tintColor = UIColor.healeatGreen1
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
