//
//  QRScannerViewCoordinator.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

protocol QRScannerViewModelDelegate: AnyObject {
    // Opens the task manager using a QR query string.
    ///
    /// - Parameter query: The QR query string to filter tasks in the task manager.
    func openTaskManagerWithQRQuery(_ query: String)
    
    /// Displays an alert indicating that the camera is unavailable.
    func showNoCameraAlert()
}

class QRScannerViewCoordinator: Coordinator, QRScannerViewModelDelegate {
    
    // MARK: - Properties
    private var navController: UINavigationController
    
    // MARK: - Initializer
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Coordinator Start
    override func start() {
        guard let qrScannerVC = QRScannerViewController.initFromStoryBoard() else { return }
        
        qrScannerVC.viewModel = QRScannerViewModel(delegate: self)
        navController.pushViewController(qrScannerVC, animated: true)
    }

    // MARK: - QRScannerViewModelDelegate
    func openTaskManagerWithQRQuery(_ query: String) {
        guard let parentCoordinator = firstParent(of: AppCoordinator.self) else { return }

        parentCoordinator.navigateToTaskCoordinatorWithQRQuery(query: query)
    }

    func showNoCameraAlert() {
        let alert = UIAlertController(
            title: QRScannerViewConstants.cameraUnavailableTitle,
            message: QRScannerViewConstants.cameraUnavailableMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: QRScannerViewConstants.okActionTitle, style: .default))
        navController.present(alert, animated: true)
    }
}
