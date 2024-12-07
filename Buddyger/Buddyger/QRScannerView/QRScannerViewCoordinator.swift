//
//  QRScannerViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class QRScannerViewCoordinator: Coordinator {
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    override func start() {
        guard let qrScannerVC = QRScannerViewController.initFromStoryBoard() else { return }
        
        qrScannerVC.viewModel = QRScannerViewModel(coordinator: self)
        navController.pushViewController(qrScannerVC, animated: true)
    }

    func openTaskManagerWithQRquery(query: String) {
        guard let tabBarCoordinator = parentCoordinator?.firstChildCoordinatorRecursive(of: TabBarCoordinator.self) else { return }

        tabBarCoordinator.switchToTab(.tasksList)
        
        if let tasksCoordinator = parentCoordinator?.firstChildCoordinator(of: TasksListViewCoordinator.self) {
            tasksCoordinator.startSearchFlowWithQRQuery(query: query)
        }
    }
    
}
