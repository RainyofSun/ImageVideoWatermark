//
//  HSVideoWatermarkInfoModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/13.
//

import UIKit

let K_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
let K_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

// MARK: 视频水印元素的基础信息
class HSVideoWatermarkInfoModel: NSObject {
    // 编辑时的size
    var originalSize: CGSize? = .zero
    // 编辑时的坐标点
    var originalPoint: CGPoint? = .zero
    
    private let heightScale: CGFloat = 0.6
    private let widthScale: CGFloat = 0.6 * (K_SCREEN_WIDTH / K_SCREEN_HEIGHT)
    
    /// 获取转换后的size
    public func getTransformSize() -> CGSize {
        guard let size = originalSize else {
            return .zero
        }
        let originalWidthScale = size.width / (K_SCREEN_HEIGHT * widthScale)
        let originalHeightScale = size.height / (K_SCREEN_HEIGHT * heightScale)
        
        let w: CGFloat = K_SCREEN_WIDTH * originalWidthScale
        let h: CGFloat = K_SCREEN_HEIGHT * originalHeightScale
        print("转换前 w = \(size.width) h = \(size.height) 转换后 w = \(w) h = \(h)")
        return CGSize.init(width: UIScreen.main.bounds.height * widthScale, height: h)
    }
    
    /// 获取转换后的Origin
    public func getTransformOrigin() -> CGPoint {
        guard let point = originalPoint else {
            return .zero
        }
        let originalWidthScale = point.x / (K_SCREEN_HEIGHT * widthScale)
        let originalHeightScale = point.y / (K_SCREEN_HEIGHT * heightScale)
        let x: CGFloat = K_SCREEN_WIDTH * originalWidthScale
        let y: CGFloat = K_SCREEN_HEIGHT * originalHeightScale
        print("转换前 x = \(point.x) y = \(point.y) 转换后 x = \(x) y = \(y)")
        return CGPoint.init(x: x, y: y)
    }
    
    deinit {
        deallocPrint()
    }
}
