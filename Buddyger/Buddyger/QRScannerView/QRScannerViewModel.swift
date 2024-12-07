//
//  QRScannerViewModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import Foundation

class QRScannerViewModel {
    
    private var coordinator: QRScannerViewCoordinator
    
    init(coordinator: QRScannerViewCoordinator) {
        self.coordinator = coordinator
    }
    
    func searchWithQRSquery(query: String) {
        coordinator.openTaskManagerWithQRquery(query: query)
    }
    
}

class TaskManager {
    static let shared = TaskManager()
    private init() {}
    
    @Published var searchTextPublisher: String = ""
}
