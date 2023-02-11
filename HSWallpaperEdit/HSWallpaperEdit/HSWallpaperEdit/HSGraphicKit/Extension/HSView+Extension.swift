//
//  HSView+Extension.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import Foundation
import UIKit

extension UIView {
    /// 切割圆角
    func clipRound(roundBounds: CGRect ,radius: CGSize, corner: UIRectCorner) {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: roundBounds, byRoundingCorners: corner, cornerRadii: radius)
        let maskLayer: CAShapeLayer = CAShapeLayer.init()
        maskLayer.frame = roundBounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 控件截图
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
}
