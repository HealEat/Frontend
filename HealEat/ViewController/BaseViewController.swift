//
//  ViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.08.
//

import UIKit

class BaseViewController: UITabBarController {
    
    private let homeViewController = UINavigationController(rootViewController: HomeViewController())
    private let searchViewController = UINavigationController(rootViewController: SearchViewController())
    private let healthGoalViewController = UINavigationController(rootViewController: HealthGoalViewController())
    private let myPageViewController = UINavigationController(rootViewController: MyPageViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.viewControllers = [
            homeViewController,
            searchViewController,
            healthGoalViewController,
            myPageViewController,
        ]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .black
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        self.tabBar.tintColor = .black
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(), tag: 0)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(), tag: 1)
        healthGoalViewController.tabBarItem = UITabBarItem(title: "HealthGoal", image: UIImage(), tag: 2)
        myPageViewController.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(), tag: 3)
        
//        homeViewController.tabBarItem.selectedImage = UIImage(named: "icon_home_fill")
//        styleViewController.tabBarItem.selectedImage = UIImage(named: "icon_style_fill")
//        shopViewController.tabBarItem.selectedImage = UIImage(named: "icon_shop_fill")
//        savedViewController.tabBarItem.selectedImage = UIImage(named: "icon_saved_fill")
        
        
        self.selectedIndex = 4
    }


}

