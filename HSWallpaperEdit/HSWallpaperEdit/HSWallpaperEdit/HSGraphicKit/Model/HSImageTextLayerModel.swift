//
//  HSImageTextLayerModel.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

import UIKit

class HSImageTextLayerModel: NSObject {
    var type: Int?                      // 内容类型 0文字 1图片
    var rotate: CGFloat?                // 旋转角度
    var scale: CGFloat?                 // 缩放
    var textInfo: HSTextInfoModel?       // 文本信息
    var imageInfo: HSImageInfoModel?     // 图片信息
    
    override init() {
        super.init()
        self.textInfo = HSTextInfoModel.init()
        self.imageInfo = HSImageInfoModel.init()
    }
}
