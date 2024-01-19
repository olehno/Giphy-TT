//
//  MainViewController.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 29/12/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let vc1 = UINavigationController(rootViewController: SearchViewController())
        let vc2 = UINavigationController(rootViewController: FavoriteViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        
        vc1.title = "Search"
        vc2.title = "Favorite"

        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }


}
