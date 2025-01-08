//
//  ViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.08.
//

import UIKit

class BaseVC: UITabBarController {
    
    private let homeVC = UINavigationController(rootViewController: HomeVC())
    private let searchVC = UINavigationController(rootViewController: SearchVC())
    private let healthGoalVC = UINavigationController(rootViewController: HealthGoalVC())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.viewControllers = [
            homeVC,
            searchVC,
            healthGoalVC,
            myPageVC,
        ]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .black
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        self.tabBar.tintColor = .black
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(), tag: 1)
        healthGoalVC.tabBarItem = UITabBarItem(title: "HealthGoal", image: UIImage(), tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(), tag: 3)
        
//        homeViewController.tabBarItem.selectedImage = UIImage(named: "icon_home_fill")
//        styleViewController.tabBarItem.selectedImage = UIImage(named: "icon_style_fill")
//        shopViewController.tabBarItem.selectedImage = UIImage(named: "icon_shop_fill")
//        savedViewController.tabBarItem.selectedImage = UIImage(named: "icon_saved_fill")
        
        
        self.selectedIndex = 4
    }


}

