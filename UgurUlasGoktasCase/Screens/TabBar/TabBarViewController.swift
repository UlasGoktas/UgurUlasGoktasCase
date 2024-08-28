//
//  TabBarViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    let viewModel = TabBarViewModel()
    let productListViewController = UINavigationController(rootViewController: ProductListViewController())
    let cartViewController = UINavigationController(rootViewController: CartViewController())
    let favoriteListViewController = UINavigationController(rootViewController: FavoriteListViewController())
    let profileViewController = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTabBarItems()
        addViewControllersToTabBar()
    }
    
    private func prepareTabBarItems() {
        productListViewController.tabBarItem = UITabBarItem(title: .empty, image: UIImage(systemName: SystemImages.house.rawValue), tag: 0)
        cartViewController.tabBarItem = UITabBarItem(title: .empty, image: UIImage(systemName: SystemImages.cart.rawValue), tag: 1)
        favoriteListViewController.tabBarItem = UITabBarItem(title: .empty, image: UIImage(systemName: SystemImages.star.rawValue), tag: 2)
        profileViewController.tabBarItem = UITabBarItem(title: .empty, image: UIImage(systemName: SystemImages.person.rawValue), tag: 3)
    }
    
    private func addViewControllersToTabBar() {
        viewControllers = [
            productListViewController,
            cartViewController,
            favoriteListViewController,
            profileViewController
        ]
    }
}
