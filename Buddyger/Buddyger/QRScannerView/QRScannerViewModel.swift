//
//  QRScannerViewModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import Foundation

protocol QRScannerViewModelProtocol {
    /// Handles the QR scan and triggers task management navigation.
    /// - Parameter query: The QR code content to search with.
    func searchWithQRSquery(query: String)
    
    /// Handles the case when no camera is available.
    func handleNoCamera()
}

class QRScannerViewModel: QRScannerViewModelProtocol {
    
    // MARK: - Properties
    private weak var delegate: QRScannerViewModelDelegate?
    
    // MARK: - Initialization
    init(delegate: QRScannerViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Protocol Methods
    func searchWithQRSquery(query: String) {
        delegate?.openTaskManagerWithQRQuery(query)
    }

    func handleNoCamera() {
        delegate?.showNoCameraAlert()
    }
}
