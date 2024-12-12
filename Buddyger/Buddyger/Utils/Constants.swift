//
//  Constants.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 11.12.24.
//

import Foundation
import AVFoundation
import UIKit


struct APIConstants {
    static let baseURL = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
    static let authorizationHeader = "Authorization"
    static let contentTypeHeader = "Content-Type"
    static let bearerPrefix = "Bearer"
    static let contentTypeJSON = "application/json"
}

struct CoreDataConstants {
    static let containerName = "Buddyger"
}

struct AuthAPIConstants {
    static let baseURL = "https://api.baubuddy.de/index.php/login"
    static let username = "365"
    static let password = "1"
    static let authorizationHeader = "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz"
    static let contentType = "application/json"
}

struct QRScannerViewConstants {
    static let cameraUnavailableTitle = "Camera Unavailable"
    static let cameraUnavailableMessage = "No camera device found. Please check your device and try again."
    static let okActionTitle = "OK"
}

struct TaskListConstants {
    static let taskCellIdentifier = "TaskCell"
    static let noTaskPlaceholder = "no task"
    static let noTitlePlaceholder = "no title"
    static let noDescriptionPlaceholder = "no description"
    static let estimatedRowHeight: CGFloat = 44
}

struct TasksListViewModelConstants {
    static let loginError = "Error: Login response is nil"
    static let authResponseError = "Error fetching auth response from server: "
    static let fetchTasksError = "Error fetching tasks from API: "
}

struct TaskTableViewCellConstants {
    static let colorViewCornerRadius: CGFloat = 5
    static let colorViewWidth: CGFloat = 8
    static let colorViewHeight: CGFloat = 40
    static let titleLabelFontSize: CGFloat = 16
    static let descriptionLabelFontSize: CGFloat = 14
    static let titleLabelTopPadding: CGFloat = 10
    static let descriptionLabelTopPadding: CGFloat = 5
    static let descriptionLabelBottomPadding: CGFloat = -10
    static let horizontalPadding: CGFloat = 15
}

struct QRScannerViewControllerConstants {
    static let cameraDeviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera, .builtInDualCamera]
    static let cameraMediaType: AVMediaType = .video
    static let cameraPosition: AVCaptureDevice.Position = .back
    static let qrCodeBorderColor: UIColor = .green
    static let qrCodeBorderWidth: CGFloat = 2
    static let alertTitle: String = "QR Code Detected"
    static let alertMessagePrefix: String = "QR Code: "
    static let alertOKActionTitle: String = "OK"
}
