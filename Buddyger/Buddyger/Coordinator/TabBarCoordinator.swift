//
//  TabBarCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

class TabBarCoordinator: Coordinator {

    //MARK: - Properties
    private var rootNavController: UINavigationController
    private let pages: [TabBarPage] = [.tasksList, .qrScanner]
        .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
    private weak var tabBarController: TabBarController?
    
    //MARK: - Initializer
    init(rootNavController: UINavigationController) {
        self.rootNavController = rootNavController
    }
    
    //MARK: - Methods
    override func start() {
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        guard let tabBarController = TabBarController.initFromStoryBoard() else { return }

        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.tasksList.pageOrderNumber()
        self.tabBarController = tabBarController
        rootNavController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
            navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                         image: page.pageIcon(),
                                                         tag: page.pageOrderNumber())

            switch page {
            case .tasksList:
                let tasksViewCoordinator = TasksListViewCoordinator(navController: navController)
                parentCoordinator?.addChildCoordinator(tasksViewCoordinator)
                tasksViewCoordinator.start()
            case .qrScanner:
                let qrScannerViewCoordinator = QRScannerViewCoordinator(navController: navController)
                parentCoordinator?.addChildCoordinator(qrScannerViewCoordinator)
                qrScannerViewCoordinator.start()
            }

            return navController
        }
    
    func switchToTab(_ tab: TabBarPage) {
        guard let index = pages.firstIndex(of: tab) else { return }
        tabBarController?.switchToTab(index: index)
    }

}
