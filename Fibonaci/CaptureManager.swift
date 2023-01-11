//
//  CaptureManager.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 10/01/2023.
//

/*
 
import Foundation
import UIKit
import AVFoundation

protocol CaptureManagerDelegate: class {
    func processCapturedImage(image: UIImage)
}

class CaptureManager: NSObject {
    internal static let shared = CaptureManager()
    weak var delegate: CaptureManagerDelegate?
    var session: AVCaptureSession?
    
    override init() {
        super.init()
        session = AVCaptureSession()
        
        //setup input
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        let input = AVCaptureDeviceInput(device: device!)
        session?.addInput(input)
        
        //setup output
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        session?.addOutput(output)
    }
    
    func statSession() {
        session?.startRunning()
    }
    func stopSession() {
        session?.stopRunning()
    }
    
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
}

extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        delegate?.processCapturedImage(image: outputImage)
    }
}
*/
