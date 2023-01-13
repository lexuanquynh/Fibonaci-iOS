//
//  CameraViewController.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 12/01/2023.
//

import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    private let preview: Preview = .init(frame: .zero)
    private let camera = Camera()
    private var qrcodeIsDetect = false
    
    private lazy var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cropImageView: UIImageView = {
        let imageView = UIImageView()
        // set opacity
        imageView.alpha = 0.5
        // color with opacity
        imageView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        self.view.addSubview(self.cropImageView)
        // add contraints
        self.cropImageView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.bringSubviewToFront(cropImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.startSession()
    }
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage? {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        if croppedCGImage == nil {
            return nil
        }
        return UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
    }
    
    func cropImage2(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}

private extension CameraViewController {
    func configure() {
        view.addSubview(preview)
        view.topAnchor.constraint(equalTo: preview.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: preview.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: preview.trailingAnchor).isActive = true
        preview.heightAnchor.constraint(equalToConstant: 500).isActive = true
        preview.session = camera.captureSession
        
       
        camera.setSampleBufferDelegate(self)
        camera.setMetadataObjectsDelegate(self)
        
        view.addSubview(qrCodeFrameView)
        view.bringSubviewToFront(qrCodeFrameView)
               
    }
}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Get the metadata object.
        if metadataObjects.count == 0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.qrCodeFrameView.frame = CGRect.zero
            }
            print("No QR code is detected")
            qrcodeIsDetect = false
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            qrcodeIsDetect = true
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = preview.videoPreviewLayer.transformedMetadataObject(for: metadataObj)
            
//            print("QR code is detected")
        // run ib main thread
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.qrCodeFrameView.frame = barCodeObject!.bounds
            }
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let bounds = strongSelf.preview.bounds
            let uiLowerLeft = bounds.origin
            let uiLowerRight = CGPoint(
                x: bounds.width,
                y: uiLowerLeft.y
            )
            let uiUpperRight = CGPoint(
                x: bounds.width,
                y: bounds.height
            )
            // supports only portrait mode
            let videoLowerLeft = strongSelf.preview.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: uiLowerRight)
            let videoUpperLeft = strongSelf.preview.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: uiLowerLeft)
            let videoLowerRight = strongSelf.preview.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: uiUpperRight)
            let uiOrigin = CGPoint(x: videoLowerLeft.y, y: videoLowerLeft.x)
            let uiSize = CGSize(
                width: videoUpperLeft.y - videoLowerLeft.y,
                height: videoLowerRight.x - videoLowerLeft.x
            )
            let uiCroppingRect = CGRect(
                x: ciImage.extent.width * uiOrigin.x,
                y: ciImage.extent.height * uiOrigin.y,
                width: ciImage.extent.width * uiSize.width,
                height: ciImage.extent.height * uiSize.height
            )
            let context = CIContext()
            if let bitmap = context.createCGImage(ciImage, from: uiCroppingRect) {
                if strongSelf.qrcodeIsDetect {
                    if strongSelf.qrCodeFrameView.frame.width == 0 {
                        return
                    }
                    let image = UIImage(cgImage: bitmap)
                    let rectToCrop = strongSelf.qrCodeFrameView.frame
                    let croppedImage: UIImage?
                    let factor = image.size.width / strongSelf.qrCodeFrameView.frame.width
                    let rect = CGRect(x: rectToCrop.origin.x / factor, y: rectToCrop.origin.y / factor, width: rectToCrop.width / factor, height: rectToCrop.height / factor)
                    croppedImage = strongSelf.cropImage1(image: image, rect: rect)
//                    let scale = self.cropImageView.frame.width/image.size.width
//                    croppedImage = self.cropImage2(image: image, rect: rectToCrop, scale: scale)
                    
                    strongSelf.cropImageView.image = croppedImage
//                    strongSelf.cropImageView.frame = strongSelf.qrCodeFrameView.frame
//                    strongSelf.cropImageView.frame = CGRect(x: 10, y: 10, width: strongSelf.qrCodeFrameView.frame.width * 2, height: strongSelf.qrCodeFrameView.frame.height * 2)
                    
                } else {
//                    self.cropImageView.image = nil
                }
            }
        }
    }
}
