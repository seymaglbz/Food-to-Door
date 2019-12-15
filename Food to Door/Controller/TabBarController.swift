//
//  TabBarController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 13.12.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = "Food to Door"
        setupTabBarItems()
    }
    
    func setupTabBarItems() {
        let exploreVC = ExploreViewController()
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "tab-explore"), tag: 0)
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "tab-star"), tag: 1)
        let viewControllersList = [exploreVC, favoritesVC]
        viewControllers = viewControllersList.map{UINavigationController(rootViewController: $0)}
        
        delegate = self
        self.tabBar.tintColor = .red
        selectedIndex = 0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let navController = tabBarController.viewControllers?[0] as? UINavigationController{
            navController.popToRootViewController(animated: true)
        }
        if let navController = tabBarController.viewControllers?[1] as? UINavigationController{
            navController.popToRootViewController(animated: true)
        }
    }
}
