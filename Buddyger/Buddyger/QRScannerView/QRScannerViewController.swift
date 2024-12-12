//
//  QRScannerViewController.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 4.12.24.
//

import UIKit
import AVFoundation
import os

class QRScannerViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: QRScannerViewModel?
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrame: UIView = UIView()
    private var isScanning = true
    private let logger = Logger(subsystem: "oniqotlqvo.Buddyger", category: "Camera")
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeQRScanner()
    }
    
    // MARK: - QR Scanner Setup
    private func initializeQRScanner() {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: QRScannerViewControllerConstants.cameraDeviceTypes,
            mediaType: QRScannerViewControllerConstants.cameraMediaType,
            position: QRScannerViewControllerConstants.cameraPosition
        )
        
        guard let captureDevice = discoverySession.devices.first else {
            logger.error("No camera device found.")
            viewModel?.handleNoCamera()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            if let videoLayer = videoPreviewLayer {
                view.layer.addSublayer(videoLayer)
            }
            
            qrCodeFrame.layer.borderColor = QRScannerViewControllerConstants.qrCodeBorderColor.cgColor
            qrCodeFrame.layer.borderWidth = QRScannerViewControllerConstants.qrCodeBorderWidth
            view.addSubview(qrCodeFrame)
            view.bringSubviewToFront(qrCodeFrame)

            captureSession.startRunning()
        } catch {
            logger.error("Error setting up QR scanner: \(error.localizedDescription)")
        }
    }

}

// MARK: - Metadata Output Delegate
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard isScanning, !metadataObjects.isEmpty else {
            qrCodeFrame.frame = .zero
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metadataObject.type == .qr,
           let qrCodeValue = metadataObject.stringValue {
            
            isScanning = false
            captureSession.stopRunning()
            
            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) {
                qrCodeFrame.frame = barCodeObject.bounds
            }
            
            let alert = UIAlertController(
                title: QRScannerViewControllerConstants.alertTitle,
                message: QRScannerViewControllerConstants.alertMessagePrefix + qrCodeValue,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: QRScannerViewControllerConstants.alertOKActionTitle, style: .default) { _ in
                self.viewModel?.searchWithQRSquery(query: qrCodeValue)
                self.resumeScanning()
            })
            present(alert, animated: true)
        }
    }
    
    // MARK: - Scanning Control
    private func resumeScanning() {
        isScanning = true
        qrCodeFrame.frame = .zero
        captureSession.startRunning()
    }
}
