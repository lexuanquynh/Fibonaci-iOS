//
// Created by Le Xuan Quynh on 09/01/2023.
//

import Foundation
import UIKit


class QRCodeUtils {
    // detect the QR code from an image
    static func detectQRCode(_ image: UIImage) -> [String] {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let ciImage = CIImage(image: image)
        let features = detector?.features(in: ciImage!)
        var results = [String]()
        for feature in features as! [CIQRCodeFeature] {
            results.append(feature.messageString!)
        }
        return results
    }

    // get qrcode image from image
    static func getQRCodeImage(_ image: UIImage) -> UIImage? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let ciImage = CIImage(image: image)
        let features = detector?.features(in: ciImage!)
        if features?.count == 0 {
            return nil
        }
        let feature = features![0] as! CIQRCodeFeature
        let extent = feature.bounds
        let cgImage = CIContext().createCGImage(ciImage!, from: extent)
        return UIImage(cgImage: cgImage!)
    }

    // detect the position qr code from an image
    static func detectQRCodePosition(_ image: UIImage) -> [CGRect] {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let ciImage = CIImage(image: image)
        let features = detector?.features(in: ciImage!)
        var results = [CGRect]()
        for feature in features as! [CIQRCodeFeature] {
            results.append(feature.bounds)
        }
        return results
    }

    // get radians from a rectangle
    static func getRadians(_ points: [CGPoint]) -> CGFloat {
        let topLeft = points[0]
        let topRight = points[1]
        let radians = atan2(topRight.y - topLeft.y, topRight.x - topLeft.x)
        return radians
    }
}