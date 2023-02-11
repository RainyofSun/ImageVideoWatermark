//
//  HSGradientLayerLabel.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/15.
//

import UIKit

// MARK: 重写Layer 属性,强转为 CAGradientLayer
class HSGradientLayerLabel: UILabel {

    enum GradientDirectionStyle: Int {
        /// 从上到下
        case topToBottom = 0
        /// 从左到右
        case leftToRight
        /// 从左下到右上
        case leftBottomToRightTop
        /// 从左上到右下
        case leftTopToRightBottom
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public func createGradient(gradientColors: [UIColor], gradientStyle: GradientDirectionStyle? = .topToBottom) {
        if let gradLayer =  self.layer as?  CAGradientLayer {
            var cgColors: [CGColor] = [CGColor]()
            for item in gradientColors {
                let uColor: UIColor = item as UIColor
                cgColors.append(uColor.cgColor)
            }
            
            gradLayer.colors = cgColors
            
            var startPoint: CGPoint = CGPoint.init(x: 0.5, y: 0)
            var endPoint: CGPoint = CGPoint.init(x: 0.5, y: 1.0)
            if gradientStyle == .leftToRight {
                startPoint = CGPoint.init(x: 0, y: 0.5)
                endPoint = CGPoint.init(x: 1.0, y: 0.5)
            } else if gradientStyle == .leftTopToRightBottom {
                startPoint = CGPoint.init(x: 0, y: 0)
                endPoint = CGPoint.init(x: 1.0, y: 1.0)
            } else if gradientStyle == .leftBottomToRightTop {
                startPoint = CGPoint.init(x: 0, y: 1.0)
                endPoint = CGPoint.init(x:1.0, y: 0)
            }
            gradLayer.startPoint = startPoint
            gradLayer.endPoint = endPoint
        }
    }

    deinit {
        deallocPrint()
    }
}
