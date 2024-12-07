//
//  TabBarController.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemIndigo
        tabBar.backgroundColor = .systemGray3
        tabBar.unselectedItemTintColor = .darkGray
    }
    
    func switchToTab(index: Int) {
        guard index >= 0, index < viewControllers?.count ?? 0 else { return }
        selectedIndex = index
    }
    
}
