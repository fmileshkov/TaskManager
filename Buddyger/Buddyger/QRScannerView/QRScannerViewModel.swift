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
    
    private weak var delegate: QRScannerViewModelDelegate?
    
    init(delegate: QRScannerViewModelDelegate) {
        self.delegate = delegate
    }
    
    func searchWithQRSquery(query: String) {
        delegate?.openTaskManagerWithQRQuery(query)
    }
    
    func handleNoCamera() {
        delegate?.showNoCameraAlert()
    }
    
}
