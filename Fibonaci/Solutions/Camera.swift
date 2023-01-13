//
//  Camera.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 12/01/2023.
//

import AVFoundation
import UIKit
final class Camera {
    let captureSession = AVCaptureSession()
    private let captureSessionQueue = DispatchQueue(label: "captureSession")
    private var captureDevice: AVCaptureDevice?
    private let videoDataOutput = AVCaptureVideoDataOutput()
//    private let captureMetadataOutput = AVCaptureMetadataOutput()
    let captureMetadataOutput = AVCaptureMetadataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "videoDataOutput")
    init() {
        captureSessionQueue.async { [weak self] in
            self?.setupCamera()
        }
    }
    func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        self.captureDevice = captureDevice
        captureSession.sessionPreset = .hd1280x720
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(deviceInput) else { return }
        captureSession.addInput(deviceInput)
        guard captureSession.canAddOutput(videoDataOutput) else { return }
        captureSession.addOutput(videoDataOutput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        
        captureSession.addOutput(captureMetadataOutput)
        // Set delegate and use the default dispatch queue to execute the call back
//        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
//        guard captureSession.canAddOutput(captureMetadataOutput) else { return }
//        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
//        captureSession.addOutput(captureMetadataOutput)
        
        videoDataOutput.connection(with: .video)?.videoOrientation = .portrait                  
    }
    func startSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func setSampleBufferDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        videoDataOutput.setSampleBufferDelegate(delegate, queue: videoDataOutputQueue)
    }
    
    func setMetadataObjectsDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate) {
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: videoDataOutputQueue)
    }
}
