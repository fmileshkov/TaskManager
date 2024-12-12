//
//  TasksListViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

protocol TasksListViewModelDelegate: AnyObject {
    /// Handles searching tasks with a given QR query string.
    ///
    /// - Parameter query: The QR query string used to filter tasks.
    func searchWithQRQuery(query: String)
}

class TasksListViewCoordinator: Coordinator, TasksListViewModelDelegate {
    
    // MARK: - Properties
    private var navController: UINavigationController
    private weak var tasksVC: TasksListViewController?
    private var authRepository: AuthRepositoryProtocol

    // MARK: - Initializer
    init(navController: UINavigationController,
         authRepository: AuthRepositoryProtocol) {
        
        self.navController = navController
        self.authRepository = authRepository
    }
    
    // MARK: - Coordinator Start
    override func start() {
        startViewFlow()
    }
    
    // MARK: - Private Methods
    private func startViewFlow() {
        guard let tasksVC = TasksListViewController.initFromStoryBoard() else { return }

        tasksVC.viewModel = TasksListViewModel(
            delegate: self,
            persistenceManager: CoreDataManager(),
            authRepo: authRepository,
            tasksManagerRepository: TaskManagerRepository()
        )
        
        tasksVC.viewModel?.authenticateAndFetchTasks()
        
        navController.pushViewController(tasksVC, animated: true)
        self.tasksVC = tasksVC
    }
    
    // MARK: - TasksListViewModelDelegate
    func searchWithQRQuery(query: String) {
        guard let tasksVC = tasksVC else { return }
        
        navController.popToViewController(tasksVC, animated: true)
        tasksVC.viewModel?.searchTasks(query: query)
    }
    
}
