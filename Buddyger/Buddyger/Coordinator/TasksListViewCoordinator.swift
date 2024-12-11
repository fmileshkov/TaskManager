//
//  TasksListViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

protocol TasksListViewModelDelegate: AnyObject {
    func searchWithQRQuery(query: String)
}

class TasksListViewCoordinator: Coordinator, TasksListViewModelDelegate {
    
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
        
        tasksVC.viewModel = TasksListViewModel(delegate: self,
                                               persistenceManager: CoreDataManager(),
                                               authRepo: AuthRepository(), 
                                               tasksManagerRepository: TaskManagerRepository())
        navController.pushViewController(tasksVC, animated: true)

        self.tasksVC = tasksVC
    }

    func searchWithQRQuery(query: String) {
        guard let tasksVC = tasksVC else { return }
        
        navController.popToViewController(tasksVC, animated: true)
        tasksVC.viewModel?.searchTasks(query: query)
    }
    
}
