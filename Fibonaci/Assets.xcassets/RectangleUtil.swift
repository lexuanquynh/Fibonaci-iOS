//
// Created by Le Xuan Quynh on 09/01/2023.
//

import UIKit

class RectangleUtil {
    static func getArea(_ width: Int, _ height: Int) -> Int {
        return width * height
    }

    // generate the points of a rectangle from center point
    static func getPoints(_ center: CGPoint, _ size: CGFloat) -> [CGPoint] {
        let x = center.x
        let y = center.y
        let halfSize: CGFloat = size / 2
        let topLeft = CGPoint(x: x - halfSize, y: y - halfSize)
        let topRight = CGPoint(x: x + halfSize, y: y - halfSize)
        let bottomLeft = CGPoint(x: x - halfSize, y: y + halfSize)
        let bottomRight = CGPoint(x: x + halfSize, y: y + halfSize)
        return [topLeft, topRight, bottomLeft, bottomRight]
    }

    // get the center point of a rectangle
    static func getCenter(_ points: [CGPoint]) -> CGPoint {
        let topLeft = points[0]
        let bottomRight = points[3]
        let x = (topLeft.x + bottomRight.x) / 2
        let y = (topLeft.y + bottomRight.y) / 2
        return CGPoint(x: x, y: y)
    }

    // get size of a rectangle
    static func getSize(_ frame: CGRect) -> CGFloat {
        return frame.width
    }

    // cropImage(inView, center, 0, size)
    static func cropImage(_ imageView: UIImageView, _ center: CGPoint, _ angle: CGFloat, _ size: CGFloat) -> UIImage? {
        let image = imageView.image
        let imageViewSize = imageView.frame.size
        let scale = max(image!.size.width / imageViewSize.width, image!.size.height / imageViewSize.height)
        let widthScale = image!.size.width / imageViewSize.width
        let heightScale = image!.size.height / imageViewSize.height
        let cropSize = CGSize(width: size * scale, height: size * scale)
        let origin = CGPoint(x: (center.x * widthScale) - (cropSize.width / 2), y: (center.y * heightScale) - (cropSize.height / 2))
        let rect = CGRect(origin: origin, size: cropSize)
        let imageRef = image!.cgImage!.cropping(to: rect)
        let cropped = UIImage(cgImage: imageRef!, scale: 0, orientation: image!.imageOrientation)
        return cropped
    }

    static func cropImage(_ imageView: UIImageView, frame: CGRect) -> UIImage? {
        // check frame is valid
        if frame.origin.x < 0 || frame.origin.y < 0 || frame.size.width <= 0 || frame.size.height <= 0 {
            return nil
        }

        let image = imageView.image
        let imageViewSize = imageView.frame.size
        let scale = max(image!.size.width / imageViewSize.width, image!.size.height / imageViewSize.height)
        let widthScale = image!.size.width / imageViewSize.width
        let heightScale = image!.size.height / imageViewSize.height
        let cropSize = CGSize(width: frame.width * scale, height: frame.height * scale)
        let origin = CGPoint(x: (frame.origin.x * widthScale), y: (frame.origin.y * heightScale))
        let rect = CGRect(origin: origin, size: cropSize)
        let imageRef = image!.cgImage!.cropping(to: rect)
        if imageRef == nil {
            return nil
        }
        let cropped = UIImage(cgImage: imageRef!, scale: scale, orientation: image!.imageOrientation)
        return cropped
    }

    // get the frame by center point and size
    static func getFrame(_ center: CGPoint, _ size: CGFloat) -> CGRect {
        let halfSize: CGFloat = size / 2
        let x = center.x - halfSize
        let y = center.y - halfSize
        return CGRect(x: x, y: y, width: size, height: size)
    }


    // generate the view from a rectangle
    static func getView(_ points: [CGPoint]) -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        view.frame = CGRect(x: points[0].x, y: points[0].y, width: points[1].x - points[0].x, height: points[2].y - points[0].y)
        return view
    }

    // generate the view from [CGRect] which is the position of rectangle
    static func getView(_ rects: [CGRect]) -> UIView {
        // check size of rects
        if rects.count == 0 {
            return UIView()
        }
        let view = UIView()
        view.backgroundColor = .red
        view.frame = rects[0]
        return view
    }

    // generate the view from a rectangle with radians and size
    static func getView(_ center: CGPoint, _ radians: CGFloat, _ size: CGFloat) -> UIView {
        let points = getPoints(center, size)
        let view = getView(points)
        view.transform = CGAffineTransform(rotationAngle: radians)
        return view
    }

   
}
