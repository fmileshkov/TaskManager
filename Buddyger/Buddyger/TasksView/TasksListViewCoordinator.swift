//
//  TasksListViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class TasksListViewCoordinator: Coordinator {
    
    private var navController: UINavigationController
    private weak var tasksVC: TasksListViewController?

    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    override func start() {
        startViewFlow()
    }
    
    func startViewFlow() {
        guard let tasksVC = TasksListViewController.initFromStoryBoard() else { return }
        
        tasksVC.viewModel = TasksListViewModel(coordinator: self)
        navController.pushViewController(tasksVC, animated: true)

        self.tasksVC = tasksVC
    }

    func startSearchFlowWithQRQuery(query: String) {
        guard let tasksVC = tasksVC else { return }
        
        navController.popToViewController(tasksVC, animated: true)
        tasksVC.viewModel?.searchTasks(query: query)
    }
    
}
