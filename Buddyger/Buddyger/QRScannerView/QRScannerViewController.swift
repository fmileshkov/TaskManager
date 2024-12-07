//
//  QRScannerViewController.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 4.12.24.
//

import UIKit
import AVFoundation
import Combine

class QRScannerViewController: UIViewController {
    
    var viewModel: QRScannerViewModel?
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrame: UIView = UIView()
    private var isScanning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeQRScanner()
    }
    
    private func initializeQRScanner() {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera],
            mediaType: .video,
            position: .back
        )
        
        guard let captureDevice = discoverySession.devices.first else {
            print("No camera device found.")
            showNoCameraAlert()
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
            
            qrCodeFrame.layer.borderColor = UIColor.green.cgColor
            qrCodeFrame.layer.borderWidth = 2
            view.addSubview(qrCodeFrame)
            view.bringSubviewToFront(qrCodeFrame)

            captureSession.startRunning()
        } catch {
            print("Error setting up QR scanner: \(error.localizedDescription)")
        }
    }
    
    private func showNoCameraAlert() {
        let alert = UIAlertController(
            title: "Camera Unavailable",
            message: "No camera device found. Please check your device and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.viewModel?.searchWithQRSquery(query: "Lagerarbeiten")
        })
        present(alert, animated: true)
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
            print("No QR code detected.")
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
            
            viewModel?.searchWithQRSquery(query: qrCodeValue)

            let alert = UIAlertController(
                title: "QR Code Detected",
                message: qrCodeValue,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.resumeScanning()
            })
            present(alert, animated: true)
        }
    }
    
    private func resumeScanning() {
        isScanning = true
        qrCodeFrame.frame = .zero
        captureSession.startRunning()
    }
}
