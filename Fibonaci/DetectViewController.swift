//
//  DetectViewController.swift
//  Fibonaci
//
//  Created by Le Xuan Quynh on 11/01/2023.
//

/*
import UIKit

class DetectViewController: UIViewController {
    private  var wrapper: OpenCVWrapper!
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // add imageView
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        wrapper = OpenCVWrapper.init(parentView: imageView, delegate: self)
    }
    

}

extension DetectViewController: OpenCVWrapperDelegate {
    func openCVWrapperDidMatchImage(_ wrapper: OpenCVWrapper) {       
        print(" hello")
    }
}
*/
