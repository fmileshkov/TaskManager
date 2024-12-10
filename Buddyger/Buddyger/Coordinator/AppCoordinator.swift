//
//  AppCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private var rootNavController: UINavigationController
    
    init(rootNavController: UINavigationController) {
        self.rootNavController = rootNavController
    }
    
    override func start() {
        parentCoordinator = self
        startFlow()
    }
    
    func startFlow() {
        let tabBarCoordinator = TabBarCoordinator(rootNavController: rootNavController)
        
        parentCoordinator?.addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func navigateToTaskCoordinatorWithQRQuery(query: String) {
        guard let tasksListCoordinator = parentCoordinator?.firstChildCoordinatorRecursive(of: TasksListViewCoordinator.self) else { return }
        
        tasksListCoordinator.searchWithQRQuery(query: query)
    }
    
}
