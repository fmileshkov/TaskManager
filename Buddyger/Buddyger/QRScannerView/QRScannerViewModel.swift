//
//  QRScannerViewModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import Foundation

protocol QRScannerViewModelProtocol {
    
    func searchWithQRSquery(query: String)
    func handleNoCamera()
}

class QRScannerViewModel: QRScannerViewModelProtocol {
    
    private weak var coordinatorDelegate: QRScannerCoordinatorDelegate?
    
    init(coordinatorDelegate: QRScannerCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func searchWithQRSquery(query: String) {
        coordinatorDelegate?.openTaskManagerWithQRQuery(query)
    }
    
    func handleNoCamera() {
        coordinatorDelegate?.showNoCameraAlert()
    }
    
}
