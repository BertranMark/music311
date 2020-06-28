//
//  MainTabBarController.swift
//  music311
//
//  Created by Bertran on 20.04.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
//        let searchVC = SearchMusicViewController()
//        let libraryVC = ViewController()
        
        let searchVC : SearchViewController = SearchViewController.loadFromStoryboard()
        
        
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
            generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"), title: "Library")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title

       rootViewController.navigationItem.title = title
       navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
        
    }
}
