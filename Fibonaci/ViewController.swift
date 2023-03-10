//
//  ViewController.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 09/01/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var qrcodeIsDetect = false
    
    private lazy var captureView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()


    private var captureSession = AVCaptureSession()
//    private let photoOutput = AVCapturePhotoOutput()
    var output: AVCaptureVideoDataOutput!
    
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            // add photoOutput
            //            captureSession.addOutput(photoOutput)
            
            //setup output
            output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
            
            captureSession.addOutput(output)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer!.videoGravity = .resizeAspect
            videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer!.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            // Start video capture.
            captureSession.startRunning()


            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    private var yellowView: UIView!
    
    private func drawRectangle() {
        let center = CGPoint(x: qrCodeFrameView.frame.midX, y: qrCodeFrameView.frame.midY)
        let size = qrCodeFrameView.frame.width * 2
        let tempView = RectangleUtil.getView(center, 0, size)
        
        if yellowView == nil {
            yellowView = tempView
            yellowView.backgroundColor = .yellow
            
            self.captureView.addSubview(yellowView)
        } else {
            yellowView.frame = tempView.frame
        }
        
        
    }

    private  func cropImageRectangle()  {
        let center = CGPoint(x: qrCodeFrameView.frame.midX, y: qrCodeFrameView.frame.midY)
        let size = qrCodeFrameView.frame.width * 2
        let yellowView = RectangleUtil.getView(center, 0, size)
        
        // crop the image in the center of imageView
        let rectToCrop = yellowView.frame
        let factor = self.captureView.frame.width/rectToCrop.size.width
        let rect = CGRect(x: rectToCrop.origin.x / factor, y: rectToCrop.origin.y / factor, width: rectToCrop.width / factor, height: rectToCrop.height / factor)
        
//        guard let cropImage = RectangleUtil.cropImage(self.captureView, frame: rect) else {
//            return
//        }
        guard let targetImage = self.captureView.image,
              let cropImage = self.cropImage1(image: targetImage, rect: rect) else {
            return
        }
      
        // add cropImageView
        self.cropImageView.image = cropImage
        self.cropImageView.frame = yellowView.frame
        // check if cropImageView is already added
        if !self.captureView.contains(self.cropImageView) {
            self.captureView.addSubview(self.cropImageView)
        }
    }
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage? {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        if croppedCGImage == nil {
            return nil
        }
        return UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
    }
    
}


extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRect.zero
            print("No QR code is detected")
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView.frame = barCodeObject!.bounds
            qrcodeIsDetect = true
        }
    }
}

// AVCapturePhotoCaptureDelegate
extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        captureView.image = image
        // add to view if not exist
        if captureView.superview == nil {
            view.addSubview(captureView)
            captureView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            captureView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            captureView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            captureView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        
        // stop the session
        captureSession.stopRunning()
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        captureView.image = outputImage
        // add to view if not exist
        if captureView.superview == nil {
            view.addSubview(captureView)
            captureView.frame = videoPreviewLayer!.frame
            self.videoPreviewLayer!.frame = captureView.layer.bounds
            view.bringSubviewToFront(captureView)
        }
        
        if qrcodeIsDetect {
//            captureSession.stopRunning()
            self.drawRectangle()
            self.cropImageRectangle()


//            return
        }
    }
}
