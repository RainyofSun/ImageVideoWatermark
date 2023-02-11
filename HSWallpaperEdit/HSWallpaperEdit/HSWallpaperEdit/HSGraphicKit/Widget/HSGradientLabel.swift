//
//  HSGradientLabel.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import UIKit

// MARK: 重写绘制方法,可能会有性能上的问题,建议使用 HSGradientLayerLabel
class HSGradientLabel: UILabel {

    enum GradientDirectionType: Int {
        /// 从上到下
        case topToBottom = 0
        /// 从左到右
        case leftToRight
        /// 从左下到右上
        case leftBottomToRightTop
        /// 从左上到右下
        case leftTopToRightBottom
    }
    
    private var gradientColors: [UIColor]?
    private var type: GradientDirectionType = .topToBottom
    
    override func draw(_ rect: CGRect) {
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        var colors: [CGColor] = [CGColor]()
        for item in self.gradientColors! {
            let tempColor: UIColor = item
            colors.append(tempColor.cgColor)
        }
        context.saveGState()
        
        let gradientRef: CGGradient = CGGradient.init(colorsSpace: nil, colors: colors as CFArray, locations: nil)!
        var startPoint: CGPoint = CGPoint.init(x: rect.midX, y: rect.minY)
        var endPoint: CGPoint = CGPoint.init(x: rect.midX, y: rect.maxY)
        if self.type == .leftToRight {
            startPoint = CGPoint.init(x: rect.minX, y: rect.midY)
            endPoint = CGPoint.init(x: rect.maxX, y: rect.midY)
        } else if self.type == .leftBottomToRightTop {
            startPoint = CGPoint.init(x: rect.minX, y: rect.maxY)
            endPoint = CGPoint.init(x: rect.maxX, y: rect.minX)
        } else if self.type == .leftTopToRightBottom {
            startPoint = CGPoint.init(x: rect.minX, y: rect.minX)
            endPoint = CGPoint.init(x: rect.maxX, y: rect.maxY)
        }
        
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: [CGGradientDrawingOptions.drawsBeforeStartLocation])
        context.saveGState()
        
        super.draw(rect)
        
    }
    
    public func setGradientColorAndType(gradientColor: [UIColor], type: GradientDirectionType) {
        self.gradientColors = gradientColor
        self.type = type
    }
}
