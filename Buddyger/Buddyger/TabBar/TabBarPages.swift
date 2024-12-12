//
//  TabBarPages.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 8.12.24.
//

import UIKit

enum TabBarPage {
    case tasksList
    case qrScanner

    init?(index: Int) {
        switch index {
        case 0:
            self = .tasksList
        case 1:
            self = .qrScanner
        default:
            return nil
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .tasksList:
            return "Tasks"
        case .qrScanner:
            return "QR Scan"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .tasksList:
            return 0
        case .qrScanner:
            return 1
        }
    }

    func pageIcon() -> UIImage {
        switch self {
        case .tasksList:
            return UIImage(systemName: "rectangle.and.pencil.and.ellipsis")!
        case .qrScanner:
            return UIImage(systemName: "qrcode.viewfinder")!
        }
    }

}
