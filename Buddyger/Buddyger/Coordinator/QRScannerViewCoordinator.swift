//
//  QRScannerViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

protocol QRScannerViewModelDelegate: AnyObject {
    func openTaskManagerWithQRQuery(_ query: String)
    func showNoCameraAlert()
}

class QRScannerViewCoordinator: Coordinator, QRScannerViewModelDelegate {
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    override func start() {
        guard let qrScannerVC = QRScannerViewController.initFromStoryBoard() else { return }
        
        qrScannerVC.viewModel = QRScannerViewModel(delegate: self)
        navController.pushViewController(qrScannerVC, animated: true)
    }

    func openTaskManagerWithQRQuery(_ query: String) {
        guard let parentCoordinator = firstParent(of: AppCoordinator.self) else { return }

        parentCoordinator.navigateToTaskCoordinatorWithQRQuery(query: query)
    }
    
    func showNoCameraAlert() {
        let alert = UIAlertController(
            title: "Camera Unavailable",
            message: "No camera device found. Please check your device and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navController.present(alert, animated: true)
    }
    
}
