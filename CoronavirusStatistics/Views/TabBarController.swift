//
//  TabBarController.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private let worldStatisticsViewController: UIViewController = {
        let viewController = ViewController()
        
        let tabBarItem = UITabBarItem(title: "World statistics", image: UIImage(systemName: "heart"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    private let searchViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: SearchViewController())
        
        let tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    func setupTabBar() {
        let tabBarItems = [worldStatisticsViewController, searchViewController]
        viewControllers = tabBarItems
    }
}

