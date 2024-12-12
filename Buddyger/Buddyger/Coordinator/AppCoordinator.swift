//
//  AppCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private var rootNavController: UINavigationController
    
    // MARK: - Initializer
    init(rootNavController: UINavigationController) {
        self.rootNavController = rootNavController
    }
    
    // MARK: - Methods
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
