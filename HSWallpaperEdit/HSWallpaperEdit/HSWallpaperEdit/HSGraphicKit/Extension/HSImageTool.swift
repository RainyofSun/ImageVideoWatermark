//
//  HSImageTool.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/11.
//

import UIKit

class HSImageTool: NSObject {
    public class func scaleToSize(img: UIImage, width: CGFloat, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let orginSize = img.size
        let WHScale = orginSize.width / orginSize.height
        let newHeight = width / WHScale
        let newSize = CGSize(width: width, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        img.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg ?? img
    }
}

extension UIImage {
    class func ge_creataImage(string: String) -> UIImage? {
        let view = UILabel()
        view.text = string
        view.backgroundColor = .blue
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .center
        view.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        view.layer.cornerRadius = 17.0
        view.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    class func ge_createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
