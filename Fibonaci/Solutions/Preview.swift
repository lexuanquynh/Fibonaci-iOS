//
//  Preview.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 12/01/2023.
//

import AVFoundation
import UIKit
final class Preview: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Set `AVCaptureVideoPreviewLayer` type for Preview.layerClass.")
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    var session: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
